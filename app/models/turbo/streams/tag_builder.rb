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
#     <% # format ensures that the _entry.html.erb partial is rendered, not _entry.turbo_stream.erb %>
#     <%= render partial: "entries/entry", locals: { entry: entry }, formats: [ :html ] %>
#   <%= end %>
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
  end

  # Removes the <tt>element</tt> from the dom. The element can either be a dom id string or an object that responds to
  # <tt>to_key</tt>, which is then called and passed through <tt>ActionView::RecordIdentifier.dom_id</tt> (all Active Records
  # do). Examples:
  #
  #   <%= turbo_stream.remove "clearance_5" %>
  #   <%= turbo_stream.remove clearance %>
  def remove(element)
    action :remove, element
  end

  # Replace the <tt>element</tt> in the dom with the either the <tt>content</tt> passed in or a rendering result determined
  # by the <tt>rendering</tt> keyword arguments or the content in the block. Examples:
  #
  #   <%= turbo_stream.replace "clearance_5", "<div id='clearance_5'>Replace the dom element identified by clearance_5</div>" %>
  #   <%= turbo_stream.replace clearance, partial: "clearances/clearance", locals: { title: "Hello" } %>
  #   <%= turbo_stream.replace "clearance_5" do %>
  #     <div id='clearance_5'>Replace the dom element identified by clearance_5</div>
  #   <% end %>
  def replace(element, content = nil, **rendering, &block)
    action :replace, element, content, **rendering, &block
  end

  # Update the <tt>element</tt> in the dom with the either the <tt>content</tt> passed in or a rendering result determined
  # by the <tt>rendering</tt> keyword arguments or the content in the block. Examples:
  #
  #   <%= turbo_stream.update "clearance_5", "Update the content of the dom element identified by clearance_5" %>
  #   <%= turbo_stream.update clearance, partial: "clearances/clearance", locals: { title: "Hello" } %>
  #   <%= turbo_stream.update "clearance_5" do %>
  #     Update the content of the dom element identified by clearance_5
  #   <% end %>
  def update(container, content = nil, **rendering, &block)
    action :update, container, content, **rendering, &block
  end

  # Append to the container in the dom identified with <tt>container</tt> either the <tt>content</tt> passed in or a
  # rendering result determined by the <tt>rendering</tt> keyword arguments or the content in the block. Examples:
  #
  #   <%= turbo_stream.append "clearances", "<div id='clearance_5'>Append this to .clearances</div>" %>
  #   <%= turbo_stream.append "clearances", partial: "clearances/clearance", locals: { clearance: clearance } %>
  #   <%= turbo_stream.append "clearances" do %>
  #     <div id='clearance_5'>Append this to .clearances</div>
  #   <% end %>
  def append(container, content = nil, **rendering, &block)
    action :append, container, content, **rendering, &block
  end

  # Prepend to the container in the dom identified with <tt>container</tt> either the <tt>content</tt> passed in or a
  # rendering result determined by the <tt>rendering</tt> keyword arguments or the content in the block. Examples:
  #
  #   <%= turbo_stream.prepend "clearances", "<div id='clearance_5'>Prepend this to .clearances</div>" %>
  #   <%= turbo_stream.prepend "clearances", partial: "clearances/clearance", locals: { clearance: clearance } %>
  #   <%= turbo_stream.prepend "clearances" do %>
  #     <div id='clearance_5'>Prepend this to .clearances</div>
  #   <% end %>
  def prepend(container, content = nil, **rendering, &block)
    action :prepend, container, content, **rendering, &block
  end

  # Send an action of the type <tt>name</tt>. Options described in the concrete methods.
  def action(name, element, content = nil, **rendering, &block)
    case
    when content
      turbo_stream_action_tag name, target: element, content: content
    when block_given?
      turbo_stream_action_tag name, target: element, content: @view_context.capture(&block)
    when rendering.any?
      turbo_stream_action_tag name, target: element, content: @view_context.render(formats: [ :html ], **rendering)
    else
      turbo_stream_action_tag name, target: element
    end
  end
end
