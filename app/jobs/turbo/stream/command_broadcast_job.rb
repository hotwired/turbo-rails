# The job that powers all the <tt>broadcast_$command_later</tt> broadcasts available in <tt>Turbo::Stream::Broadcasts</tt>.
class Turbo::Stream::CommandBroadcastJob < ApplicationJob
  def perform(stream, command:, dom_id:, **rendering)
    Turbo::StreamChannel.broadcast_command_to stream, command: command, dom_id: dom_id, **rendering
  end
end
