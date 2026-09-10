module Turbo
  # Extracts the raw (unevaluated) ERB source of a turbo_frame_tag 'block:'', so
  # it can later be rendered as a standalone partial (via
  # Turbo::CachedPartialResolver) without a hand-written file backing it.
  # block.source_location gives the 'source' .erb that 'defines' the ERB element.
  class PartialExtractor
    LocalsError = Class.new(StandardError)
    CollisionError = Class.new(StandardError)

    REGISTRY_KEY = "turbo_generated_partial_registry"

    # 'collision detection' (two separate files try to define different elements with same name) is
    # only correct if it compares claims made *within the same scan* — not
    # against whatever the cache said last time. Comparing against history
    # would raise a false collision on every legitimate file rename.
    def self.hydrate_all!
      claims = {} # partial_name => { file:, source: }

      view_paths.each do |root|
        Dir.glob("#{root}/**/*.erb").each { |file| collect_claims!(file, claims) }
      end

      commit!(claims)
    end

    def self.view_paths
      Rails.application.config.paths["app/views"].existent
    end

    def self.collect_claims!(file, claims)
      original = File.read(file)
      compiled = ActionView::Template::Handlers::ERB::Erubi.new(original, escape: false, trim: true).src
      ast = RubyVM::AbstractSyntaxTree.parse(compiled)

      find_turbo_frame_tag_calls(ast).each do |node, partial_name|
        if claims.key?(partial_name) && claims[partial_name][:file] != file
          raise CollisionError,
            "Turbo::PartialExtractor: partial #{partial_name.inspect} is already defined in " \
            "#{claims[partial_name][:file]} — it can only be defined in one location. " \
            "Found a second definition in #{file}."
        end

        validate_locals!(node, partial_name)
        source = original.lines[(node.first_lineno - 1)...node.last_lineno].join
        claims[partial_name] = { file: file, source: source }
      end
    rescue SyntaxError
      nil # not every .erb file is guaranteed to compile standalone; skip it
    end

    # Cache entries for names that dropped out since the last pass (the
    # block was deleted outright, not moved) get removed — so render then
    # correctly fails loud instead of serving stale, orphaned content forever.
    def self.commit!(claims)
      stale = (Rails.cache.read(REGISTRY_KEY) || []) - claims.keys
      stale.each { |name| Rails.cache.delete(cache_key(name)) }

      claims.each { |partial_name, data| write_source!(partial_name, data[:source]) }

      Rails.cache.write(REGISTRY_KEY, claims.keys)
    end

    # Every turbo_frame_tag(..., partial: "x") do...end call in the tree,
    # paired with its partial: argument's literal string value.
    def self.find_turbo_frame_tag_calls(node, results = [])
      return results unless node.is_a?(RubyVM::AbstractSyntaxTree::Node)

      if node.type == :ITER && call_method_name(node.children[0]) == :turbo_frame_tag
        partial_name = partial_kwarg(node.children[0])
        results << [node, partial_name] if partial_name
      end

      node.children.each { |child| find_turbo_frame_tag_calls(child, results) }
      results
    end

    # Boot-time (and dev-reload-time, via config.to_prepare) hydration: scan
    # every .erb file directly for turbo_frame_tag(..., partial: "x") calls
    # and cache all of them upfront. Without this, a partial only exists once
    # its defining page has rendered at least once — landing cold on a page
    # that only *consumes* the partial (never defines it) fails.
    #
    # Two phases, not one, and that split matters: collision detection is
    # only correct if it compares claims made *within the same scan* — not
    # against whatever the cache said last time. Comparing against history
    # would raise a false collision on every legitimate rename (the old file
    # hasn't been re-scanned yet this pass to confirm it dropped the name).
    def self.hydrate_all!
      claims = {} # partial_name => { file:, source: }

      view_paths.each do |root|
        Dir.glob("#{root}/**/*.erb").each { |file| collect_claims!(file, claims) }
      end

      commit!(claims)
    end

    def self.view_paths
      Rails.application.config.paths["app/views"].existent
    end

    def self.collect_claims!(file, claims)
      original = File.read(file)
      compiled = ActionView::Template::Handlers::ERB::Erubi.new(original, escape: false, trim: true).src
      ast = RubyVM::AbstractSyntaxTree.parse(compiled)

      find_turbo_frame_tag_calls(ast).each do |node, partial_name|
        if claims.key?(partial_name) && claims[partial_name][:file] != file
          raise CollisionError,
            "Turbo::PartialExtractor: partial #{partial_name.inspect} is already defined in " \
            "#{claims[partial_name][:file]} — it can only be defined in one location. " \
            "Found a second definition in #{file}."
        end

        validate_locals!(node, partial_name)
        source = original.lines[(node.first_lineno - 1)...node.last_lineno].join
        claims[partial_name] = { file: file, source: source }
      end
    rescue SyntaxError
      nil # not every .erb file is guaranteed to compile standalone; skip it
    end

    # Cache entries for names that dropped out since the last pass (the
    # block was deleted outright, not moved) get removed — so render then
    # correctly fails loud instead of serving stale, orphaned content forever.
    def self.commit!(claims)
      stale = (Rails.cache.read(REGISTRY_KEY) || []) - claims.keys
      stale.each { |name| Rails.cache.delete(cache_key(name)) }

      claims.each { |partial_name, data| write_source!(partial_name, data[:source]) }

      Rails.cache.write(REGISTRY_KEY, claims.keys)
    end

    # Every turbo_frame_tag(..., partial: "x") do...end call in the tree,
    # paired with its partial: argument's literal string value.
    def self.find_turbo_frame_tag_calls(node, results = [])
      return results unless node.is_a?(RubyVM::AbstractSyntaxTree::Node)

      if node.type == :ITER && call_method_name(node.children[0]) == :turbo_frame_tag
        partial_name = partial_kwarg(node.children[0])
        results << [node, partial_name] if partial_name
      end

      node.children.each { |child| find_turbo_frame_tag_calls(child, results) }
      results
    end

    # The lazy, single-block path, triggered whenever the defining page
    # happens to render. Deliberately no collision check here — it only ever
    # sees one block at a time, with no visibility into what else might claim
    # the same name, so it can't detect collisions correctly (see hydrate_all!
    # above). It's a fallback the next authoritative to_prepare pass corrects.
    def self.ensure_generated!(partial_name, block)
      file, approx_line = block.source_location
      return unless file && File.exist?(file)

      original = File.read(file)
      compiled = ActionView::Template::Handlers::ERB::Erubi.new(original, escape: false, trim: true).src
      ast = RubyVM::AbstractSyntaxTree.parse(compiled)
      node = closest_iter_node(ast, approx_line)

      unless node
        raise "Turbo::PartialExtractor could not locate the turbo_frame_tag block for " \
              "partial #{partial_name.inspect} near #{file}:#{approx_line}"
      end

      validate_locals!(node, partial_name)
      source = original.lines[(node.first_lineno - 1)...node.last_lineno].join
      write_source!(partial_name, source)
    end

    def self.validate_locals!(node, partial_name)
      referenced = Set.new
      assigned = Set.new
      scan_variables(node, referenced, assigned)

      leaked = referenced - assigned - locals_kwarg_keys(node.children[0])
      return if leaked.empty?

      raise LocalsError,
        "Turbo::PartialExtractor: partial #{partial_name.inspect} references " \
        "#{leaked.to_a.sort.join(", ")} which #{leaked.size == 1 ? "isn't" : "aren't"} passed via locals: — " \
        "it works inline (Ruby closures see outer locals) but will raise NameError the moment this same " \
        "source renders standalone anywhere else. Add #{leaked.size == 1 ? "it" : "them"} to locals: { ... }."
    end

    def self.scan_variables(node, referenced, assigned)
      return unless node.is_a?(RubyVM::AbstractSyntaxTree::Node)

      assigned.merge(Array(node.children[0]).map(&:to_s)) if node.type == :SCOPE
      referenced << node.children[0].to_s if node.type == :LVAR || node.type == :DVAR

      node.children.each { |child| scan_variables(child, referenced, assigned) }
    end

    def self.write_source!(partial_name, source)
      key = cache_key(partial_name)
      Rails.cache.write(key, source) unless Rails.cache.read(key) == source
    end

    def self.cache_key(partial_name)
      "turbo_generated_partial/#{partial_name}"
    end

    def self.closest_iter_node(node, approx_line, best = nil)
      return best unless node.is_a?(RubyVM::AbstractSyntaxTree::Node)

      if node.type == :ITER && call_method_name(node.children[0]) == :turbo_frame_tag
        if best.nil? || (node.first_lineno - approx_line).abs < (best.first_lineno - approx_line).abs
          best = node
        end
      end

      node.children.each { |child| best = closest_iter_node(child, approx_line, best) }
      best
    end

    def self.call_method_name(call_node)
      return nil unless call_node.is_a?(RubyVM::AbstractSyntaxTree::Node)
      case call_node.type
      when :FCALL, :VCALL, :QCALL
        call_node.children[0]
      when :CALL
        call_node.children[1]
      end
    end

    def self.kwarg_value_node(fcall_node, name)
      return nil unless fcall_node.is_a?(RubyVM::AbstractSyntaxTree::Node)
      args_list = fcall_node.children[1]
      return nil unless args_list.is_a?(RubyVM::AbstractSyntaxTree::Node)

      hash_node = args_list.children.find { |c| c.is_a?(RubyVM::AbstractSyntaxTree::Node) && c.type == :HASH }
      return nil unless hash_node

      pairs = hash_node.children[0]
      return nil unless pairs.is_a?(RubyVM::AbstractSyntaxTree::Node)

      elements = pairs.children.select { |c| c.is_a?(RubyVM::AbstractSyntaxTree::Node) }
      elements.each_slice(2) do |key, value|
        return value if key.type == :LIT && key.children[0] == name
      end
      nil
    end

    def self.partial_kwarg(fcall_node)
      value = kwarg_value_node(fcall_node, :partial)
      value.children[0] if value&.type == :STR
    end

    def self.locals_kwarg_keys(fcall_node)
      value = kwarg_value_node(fcall_node, :locals)
      return [] unless value&.type == :HASH

      pairs = value.children[0]
      return [] unless pairs.is_a?(RubyVM::AbstractSyntaxTree::Node)

      pairs.children.select { |c| c.is_a?(RubyVM::AbstractSyntaxTree::Node) }
        .each_slice(2).filter_map { |key, _value| key.children[0].to_s if key.type == :LIT }
    end
  end
end
