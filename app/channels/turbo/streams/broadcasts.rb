# Provides the broadcast commands in synchronous and asynchrous form for the <tt>Turbo::StreamsChannel</tt>.
# This is not meant to be used directly. See <tt>Turbo::Broadcastable</tt> for the user-facing API that invokes
# these methods with most of the paperwork filled out already.
#
# It is however possible to use it directly like <tt>Turbo::StreamsChannel.broadcast_remove_to :entries, element: 1</tt>.
module Turbo::Streams::Broadcasts
  def broadcast_remove_to(*streamables, element:)
    broadcast_command_to *streamables, command: :remove, dom_id: element
  end

  def broadcast_replace_to(*streamables, element:, **rendering)
    broadcast_command_to *streamables, command: :replace, dom_id: element, **rendering
  end

  def broadcast_append_to(*streamables, container:, **rendering)
    broadcast_command_to *streamables, command: :append, dom_id: container, **rendering
  end

  def broadcast_prepend_to(*streamables, container:, **rendering)
    broadcast_command_to *streamables, command: :prepend, dom_id: container, **rendering
  end

  def broadcast_command_to(*streamables, command:, dom_id:, **rendering)
    broadcast_update_to *streamables, content: turbo_stream_action(command, dom_id, content:
      rendering.delete(:content) || (rendering.any? ? render_format(:html, **rendering) : nil)
    )
  end


  def broadcast_replace_later_to(*streamables, element:, **rendering)
    broadcast_command_later_to *streamables, command: :replace, dom_id: element, **rendering
  end

  def broadcast_append_later_to(*streamables, container:, **rendering)
    broadcast_command_later_to *streamables, command: :append, dom_id: container, **rendering
  end

  def broadcast_prepend_later_to(*streamables, container:, **rendering)
    broadcast_command_later_to *streamables, command: :prepend, dom_id: container, **rendering
  end

  def broadcast_command_later_to(*streamables, command:, dom_id:, **rendering)
    Turbo::Streams::CommandBroadcastJob.perform_later \
      stream_name_from(streamables), command: command, dom_id: dom_id, **rendering
  end


  def broadcast_render_to(*streamables, **rendering)
    broadcast_update_to *streamables, content: render_format(:turbo_stream, **rendering)
  end

  def broadcast_render_later_to(*streamables, **rendering)
    Turbo::Streams::BroadcastJob.perform_later stream_name_from(streamables), **rendering
  end

  def broadcast_update_to(*streamables, content:)
    ActionCable.server.broadcast stream_name_from(streamables), content
  end


  private
    def turbo_stream_action(command, element_or_dom_id, content: nil)
      %(<turbo-stream action="#{command}" target="#{convert_to_dom_id(element_or_dom_id)}"><template>#{content}</template></turbo-stream>)
    end

    def convert_to_dom_id(element_or_dom_id)
      if element_or_dom_id.respond_to?(:to_key)
        element = element_or_dom_id
        ActionView::RecordIdentifier.dom_id(element)
      else
        dom_id = element_or_dom_id
      end
    end

    def render_format(format, **rendering)
      ApplicationController.render(formats: [ format ], **rendering)
    end
end
