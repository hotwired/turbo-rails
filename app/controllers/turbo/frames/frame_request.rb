# Turbo frame requests are requests made from within a turbo frame with the intention of replacing the content of just
# that frame, not the whole page. They are automatically tagged as such by the Turbo Frame JavaScript, which adds a
# <tt>Turbo-Frame</tt> header to the request.
#
# This module is automatically included in <tt>ActionController::Base</tt>.
module Turbo::Frames::FrameRequest
  extend ActiveSupport::Concern

  private
    def turbo_frame_request?
      request.headers["Turbo-Frame"].present?
    end
end
