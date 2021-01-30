# This tag builder is used both for inline controller turbo actions (see <tt>Turbo::Streams::TurboStreamsTagBuilder</tt>) and for
# turbo stream templates. This object plays together with any normal Ruby you'd run in an ERB template, so you can iterate, like:
#
#   <% # app/views/postings/destroy.turbo_stream.erb %>
#   <% @postings.each do |posting| %>
#     <%= turbo_stream.remove posting %>
#   <% end %>
#
# Or string several separate updates together:
#
#   <% # app/views/entries/_entry.turbo_stream.erb %>
#   <%= turbo_stream.remove entry %>
#
#   <%= turbo_stream.append "entries" do %>
#     <% # format is automatically switched, such that _entry.html.erb partial is rendered, not _entry.turbo_stream.erb %>
#     <%= render partial: "entries/entry", locals: { entry: entry } %>
#   <% end %>
#
# Or you can render the HTML that should be part of the update inline:
#
#   <% # app/views/topics/merges/_merge.turbo_stream.erb %>
#   <%= turbo_stream.append dom_id(topic_merge) do %>
#     <%= link_to topic_merge.topic.name, topic_path(topic_merge.topic) %>
#   <% end %>
class Turbo::Streams::TagBuilder
  include Turbo::Streams::ActionHelper

  def initialize(view_context)
    @view_context = view_context
    @view_context.formats |= [:html]
  end

  # Removes the <tt>target</tt> from the dom. The target can either be a dom id string or an object that responds to
  # <tt>to_key</tt>, which is then called and passed through <tt>ActionView::RecordIdentifier.dom_id</tt> (all Active Records
  # do). Examples:
  #
  #   <%= turbo_stream.remove "clearance_5" %>
  #   <%= turbo_stream.remove clearance %>
  def remove(target)
    action :remove, target, allow_inferred_rendering: false
  end

  # Replace the <tt>target</tt> in the dom with the either the <tt>content</tt> passed in, a rendering result determined
  # by the <tt>rendering</tt> keyword arguments, the content in the block, or the rendering of the target as a record. Examples:
  #
  #   <%= turbo_stream.replace "clearance_5", "<div id='clearance_5'>Replace the dom target identified by clearance_5</div>" %>
  #   <%= turbo_stream.replace clearance %>
  #   <%= turbo_stream.replace clearance, partial: "clearances/clearance", locals: { title: "Hello" } %>
  #   <%= turbo_stream.replace "clearance_5" do %>
  #     <div id='clearance_5'>Replace the dom target identified by clearance_5</div>
  #   <% end %>
  def replace(target, content = nil, **rendering, &block)
    action :replace, target, content, **rendering, &block
  end

  # Update the <tt>target</tt> in the dom with the either the <tt>content</tt> passed in or a rendering result determined
  # by the <tt>rendering</tt> keyword arguments, the content in the block, or the rendering of the target as a record. Examples:
  #
  #   <%= turbo_stream.update "clearance_5", "Update the content of the dom target identified by clearance_5" %>
  #   <%= turbo_stream.update clearance %>
  #   <%= turbo_stream.update clearance, partial: "clearances/unique_clearance", locals: { title: "Hello" } %>
  #   <%= turbo_stream.update "clearance_5" do %>
  #     Update the content of the dom target identified by clearance_5
  #   <% end %>
  def update(target, content = nil, **rendering, &block)
    action :update, target, content, **rendering, &block
  end

  # Append to the target in the dom identified with <tt>target</tt> either the <tt>content</tt> passed in or a
  # rendering result determined by the <tt>rendering</tt> keyword arguments, the content in the block,
  # or the rendering of the content as a record. Examples:
  #
  #   <%= turbo_stream.append "clearances", "<div id='clearance_5'>Append this to .clearances</div>" %>
  #   <%= turbo_stream.append "clearances", clearance %>
  #   <%= turbo_stream.append "clearances", partial: "clearances/unique_clearance", locals: { clearance: clearance } %>
  #   <%= turbo_stream.append "clearances" do %>
  #     <div id='clearance_5'>Append this to .clearances</div>
  #   <% end %>
  def append(target, content = nil, **rendering, &block)
    action :append, target, content, **rendering, &block
  end

  # Prepend to the target in the dom identified with <tt>target</tt> either the <tt>content</tt> passed in or a
  # rendering result determined by the <tt>rendering</tt> keyword arguments or the content in the block,
  # or the rendering of the content as a record. Examples:
  #
  #   <%= turbo_stream.prepend "clearances", "<div id='clearance_5'>Prepend this to .clearances</div>" %>
  #   <%= turbo_stream.prepend "clearances", clearance %>
  #   <%= turbo_stream.prepend "clearances", partial: "clearances/unique_clearance", locals: { clearance: clearance } %>
  #   <%= turbo_stream.prepend "clearances" do %>
  #     <div id='clearance_5'>Prepend this to .clearances</div>
  #   <% end %>
  def prepend(target, content = nil, **rendering, &block)
    action :prepend, target, content, **rendering, &block
  end

  # Send an action of the type <tt>name</tt>. Options described in the concrete methods.
  def action(name, target, content = nil, allow_inferred_rendering: true, **rendering, &block)
    target_name = extract_target_name_from(target)

    case
    when content
      turbo_stream_action_tag name, target: target_name, template: (render_record(content) if allow_inferred_rendering) || content
    when block_given?
      turbo_stream_action_tag name, target: target_name, template: @view_context.capture(&block)
    when rendering.any?
      turbo_stream_action_tag name, target: target_name, template: @view_context.render(formats: [ :html ], **rendering)
    else
      turbo_stream_action_tag name, target: target_name, template: (render_record(target) if allow_inferred_rendering)
    end
  end

  private
    def extract_target_name_from(target)
      if target.respond_to?(:to_key)
        ActionView::RecordIdentifier.dom_id(target)
      else
        target
      end
    end

    def render_record(possible_record)
      if possible_record.respond_to?(:to_partial_path)
        record = possible_record
        @view_context.render(partial: record, formats: :html)
      end
    end
end
