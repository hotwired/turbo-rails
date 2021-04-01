# The job that powers all the <tt>broadcast_$action_later</tt> broadcasts available in <tt>Turbo::Streams::Broadcasts</tt>.
class Turbo::Streams::ActionBroadcastJob < ActiveJob::Base
  def perform(stream, action:, target:, remove_if_present: nil, **rendering)
    Turbo::StreamsChannel.broadcast_action_to stream, action: action, target: target,remove_if_present: remove_if_present,  **rendering
  end
end
