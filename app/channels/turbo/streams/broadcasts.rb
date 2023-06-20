# Provides the broadcast actions in synchronous and asynchrous form for the <tt>Turbo::StreamsChannel</tt>.
# See <tt>Turbo::Broadcastable</tt> for the user-facing API that invokes these methods with most of the paperwork filled out already.
#
# Can be used directly using something like <tt>Turbo::StreamsChannel.broadcast_remove_to :entries, target: 1</tt>.
module Turbo::Streams::Broadcasts
  include Turbo::Streams::ActionHelper

  def broadcast_remove_to(*streamables, **opts)
    broadcast_action_to(*streamables, action: :remove, **opts)
  end

  def broadcast_replace_to(*streamables, **opts)
    broadcast_action_to(*streamables, action: :replace, **opts)
  end

  def broadcast_update_to(*streamables, **opts)
    broadcast_action_to(*streamables, action: :update, **opts)
  end

  def broadcast_before_to(*streamables, **opts)
    broadcast_action_to(*streamables, action: :before, **opts)
  end

  def broadcast_after_to(*streamables, **opts)
    broadcast_action_to(*streamables, action: :after, **opts)
  end

  def broadcast_append_to(*streamables, **opts)
    broadcast_action_to(*streamables, action: :append, **opts)
  end

  def broadcast_prepend_to(*streamables, **opts)
    broadcast_action_to(*streamables, action: :prepend, **opts)
  end

  def broadcast_action_to(*streamables, action:, target: nil, targets: nil, **rendering)
    broadcast_stream_to(*streamables, content: turbo_stream_action_tag(action, target: target, targets: targets, template:
      rendering.delete(:content) || rendering.delete(:html) || (rendering.any? ? render_format(:html, **rendering) : nil)
    ))
  end

  def broadcast_replace_later_to(*streamables, **opts)
    broadcast_action_later_to(*streamables, action: :replace, **opts)
  end

  def broadcast_update_later_to(*streamables, **opts)
    broadcast_action_later_to(*streamables, action: :update, **opts)
  end

  def broadcast_before_later_to(*streamables, **opts)
    broadcast_action_later_to(*streamables, action: :before, **opts)
  end

  def broadcast_after_later_to(*streamables, **opts)
    broadcast_action_later_to(*streamables, action: :after, **opts)
  end

  def broadcast_append_later_to(*streamables, **opts)
    broadcast_action_later_to(*streamables, action: :append, **opts)
  end

  def broadcast_prepend_later_to(*streamables, **opts)
    broadcast_action_later_to(*streamables, action: :prepend, **opts)
  end

  def broadcast_action_later_to(*streamables, action:, target: nil, targets: nil, **rendering)
    Turbo::Streams::ActionBroadcastJob.perform_later \
      stream_name_from(streamables), action: action, target: target, targets: targets, **rendering
  end

  def broadcast_render_to(*streamables, **rendering)
    broadcast_stream_to(*streamables, content: render_format(:turbo_stream, **rendering))
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
