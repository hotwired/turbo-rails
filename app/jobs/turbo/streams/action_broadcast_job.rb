# The job that powers all the <tt>broadcast_$action_later</tt> broadcasts available in <tt>Turbo::Streams::Broadcasts</tt>.
class Turbo::Streams::ActionBroadcastJob < ApplicationJob
  def perform(stream, action:, dom_id:, **rendering)
    Turbo::StreamsChannel.broadcast_action_to stream, action: action, dom_id: dom_id, **rendering
  end
end
