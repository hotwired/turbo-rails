# The job that powers the <tt>broadcast_render_later_to</tt> available in <tt>Turbo::Updates::Broadcasts</tt> for rendering
# page update templates.
class Turbo::Updates::BroadcastJob < ApplicationJob
  def perform(stream, **rendering)
    Turbo::UpdatesChannel.broadcast_render_to stream, **rendering
  end
end
