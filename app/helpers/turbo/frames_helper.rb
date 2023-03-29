module Turbo::FramesHelper
  # Returns a Turbo Frame id that can be used to modify a rendered Frame with
  # Turbo Streams
  #
  # === Example
  #
  #   <%# app/views/articles/show.html.erb %>
  #   <%= turbo_frame_tag(Article.find(1), "comments") %>
  #
  #   <%# app/views/comments/create.turbo_stream.erb %>
  #   <%= turbo_stream.append turbo_frame_dom_id(Article.find(1), "comments"), @comment %>
  def turbo_frame_dom_id(*ids)
    ids.map { |id| id.respond_to?(:to_key) ? ActionView::RecordIdentifier.dom_id(id) : id }.join("_")
  end

  # Returns a frame tag that can either be used simply to encapsulate frame content or as a lazy-loading container that starts empty but
  # fetches the URL supplied in the +src+ attribute.
  #
  # === Examples
  #
  #   <%= turbo_frame_tag "tray", src: tray_path(tray) %>
  #   # => <turbo-frame id="tray" src="http://example.com/trays/1"></turbo-frame>
  #
  #   <%= turbo_frame_tag tray, src: tray_path(tray) %>
  #   # => <turbo-frame id="tray_1" src="http://example.com/trays/1"></turbo-frame>
  #
  #   <%= turbo_frame_tag "tray", src: tray_path(tray), target: "_top" %>
  #   # => <turbo-frame id="tray" target="_top" src="http://example.com/trays/1"></turbo-frame>
  #
  #   <%= turbo_frame_tag "tray", target: "other_tray" %>
  #   # => <turbo-frame id="tray" target="other_tray"></turbo-frame>
  #
  #   <%= turbo_frame_tag "tray", src: tray_path(tray), loading: "lazy" %>
  #   # => <turbo-frame id="tray" src="http://example.com/trays/1" loading="lazy"></turbo-frame>
  #
  #   <%= turbo_frame_tag "tray" do %>
  #     <div>My tray frame!</div>
  #   <% end %>
  #   # => <turbo-frame id="tray"><div>My tray frame!</div></turbo-frame>
  #
  # The `turbo_frame_tag` helper will convert the arguments it receives to their
  # `dom_id` if applicable to easily generate unique ids for Turbo Frames:
  #
  #   <%= turbo_frame_tag(Article.find(1)) %>
  #   # => <turbo-frame id="article_1"></turbo-frame>
  #
  #   <%= turbo_frame_tag(Article.find(1), "comments") %>
  #   # => <turbo-frame id="article_1_comments"></turbo-frame>
  #
  #   <%= turbo_frame_tag(Article.find(1), Comment.new) %>
  #   # => <turbo-frame id="article_1_new_comment"></turbo-frame>
  def turbo_frame_tag(*ids, src: nil, target: nil, **attributes, &block)
    src = url_for(src) if src.present?

    tag.turbo_frame(**attributes.merge(id: turbo_frame_dom_id(*ids), src: src, target: target).compact, &block)
  end
end
