# Turbo frame requests are requests made from within a turbo frame with the intention of replacing the content of just
# that frame, not the whole page. They are automatically tagged as such by the Turbo Frame JavaScript, which adds a
# <tt>X-Turbo-Frame</tt> header to the request. When that header is detected by the controller, we ensure that any
# template layout is skipped (since we're only working on an in-page frame, thus can skip the weight of the layout), and
# that the etag for the page is changed (such that a cache for a layout-less request isn't served on a normal request
# and vice versa).
#
# This module is automatically included in <tt>ActionController::Base</tt>.
module Turbo::Frames::FrameRequest
  extend ActiveSupport::Concern

  included do
    layout -> { false if turbo_frame_request? }
    etag { :frame if turbo_frame_request? }
  end

  private
    def turbo_frame_request?
      request.headers["X-Turbo-Frame"].present?
    end
end
