# The job that powers all the <tt>broadcast_$action_later</tt> broadcasts available in <tt>Turbo::Streams::Broadcasts</tt>.
class Turbo::Streams::ActionBroadcastJob < ApplicationJob
  def perform(stream, action:, target:, **rendering)
    Turbo::StreamsChannel.broadcast_action_to stream, action: action, target: target, **rendering
  end
end
