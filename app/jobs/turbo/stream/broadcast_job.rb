# The job that powers the <tt>broadcast_render_later_to</tt> available in <tt>Turbo::Stream::Broadcasts</tt> for rendering
# page update templates.
class Turbo::Stream::BroadcastJob < ApplicationJob
  def perform(stream, **rendering)
    Turbo::StreamChannel.broadcast_render_to stream, **rendering
  end
end
