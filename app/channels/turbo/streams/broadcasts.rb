# Provides the broadcast actions in synchronous and asynchrous form for the <tt>Turbo::StreamsChannel</tt>.
# See <tt>Turbo::Broadcastable</tt> for the user-facing API that invokes these methods with most of the paperwork filled out already.
#
# Can be used directly using something like <tt>Turbo::StreamsChannel.broadcast_remove_to :entries, target: 1</tt>.
module Turbo::Streams::Broadcasts
  include Turbo::Streams::ActionHelper

  def broadcast_remove_to(*streamables, target:)
    broadcast_action_to *streamables, action: :remove, target: target
  end

  def broadcast_replace_to(*streamables, target:, **rendering)
    broadcast_action_to *streamables, action: :replace, target: target, **rendering
  end

  def broadcast_update_to(*streamables, target:, **rendering)
    broadcast_action_to *streamables, action: :update, target: target, **rendering
  end

  def broadcast_before_to(*streamables, target:, **rendering)
    broadcast_action_to *streamables, action: :before, target: target, **rendering
  end

  def broadcast_after_to(*streamables, target:, **rendering)
    broadcast_action_to *streamables, action: :after, target: target, **rendering
  end

  def broadcast_append_to(*streamables, target:, **rendering)
    broadcast_action_to *streamables, action: :append, target: target, **rendering
  end

  def broadcast_prepend_to(*streamables, target:, **rendering)
    broadcast_action_to *streamables, action: :prepend, target: target, **rendering
  end

  def broadcast_action_to(*streamables, action:, target:, **rendering)
    broadcast_stream_to *streamables, content: turbo_stream_action_tag(action, target: target, template:
      rendering.delete(:content) || (rendering.any? ? render_format(:html, **rendering) : nil)
    )
  end


  def broadcast_replace_later_to(*streamables, target:, **rendering)
    broadcast_action_later_to *streamables, action: :replace, target: target, **rendering
  end

  def broadcast_update_later_to(*streamables, target:, **rendering)
    broadcast_action_later_to *streamables, action: :update, target: target, **rendering
  end

  def broadcast_before_later_to(*streamables, target:, **rendering)
    broadcast_action_later_to *streamables, action: :before, target: target, **rendering
  end

  def broadcast_after_later_to(*streamables, target:, **rendering)
    broadcast_action_later_to *streamables, action: :after, target: target, **rendering
  end

  def broadcast_append_later_to(*streamables, target:, **rendering)
    broadcast_action_later_to *streamables, action: :append, target: target, **rendering
  end

  def broadcast_prepend_later_to(*streamables, target:, **rendering)
    broadcast_action_later_to *streamables, action: :prepend, target: target, **rendering
  end

  def broadcast_action_later_to(*streamables, action:, target:, **rendering)
    Turbo::Streams::ActionBroadcastJob.perform_later \
      stream_name_from(streamables), action: action, target: target, **rendering
  end


  def broadcast_render_to(*streamables, **rendering)
    broadcast_stream_to *streamables, content: render_format(:turbo_stream, **rendering)
  end

  def broadcast_render_later_to(*streamables, **rendering)
    Turbo::Streams::BroadcastJob.perform_later stream_name_from(streamables), **rendering
  end

  def broadcast_stream_to(*streamables, content:)
    ActionCable.server.broadcast stream_name_from(streamables), content
  end


  private
    def render_format(format, **rendering)
      ApplicationController.render(formats: [ format ], **rendering)
    end
end
