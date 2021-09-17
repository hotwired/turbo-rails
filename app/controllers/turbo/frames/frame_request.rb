# Turbo frame requests are requests made from within a turbo frame with the intention of replacing the content of just
# that frame, not the whole page. They are automatically tagged as such by the Turbo Frame JavaScript, which adds a
# <tt>Turbo-Frame</tt> header to the request.
#
# When the <tt>Turbo-Frame</tt> header is present, the request's <a
# href="https://guides.rubyonrails.org/4_1_release_notes.html#action-pack-variants">variant</a>
# will be marked <tt>turbo_frame</tt>.
#
# As an optimization, applications can declare a layout with the
# <tt>html+turbo_frame.erb</tt> extension that renders
# without the navigation and layout elements:
#
#     <%= app/views/layouts/application.html+turbo_frame.erb %>
#     <%= yield %>
#
# This module is automatically included in <tt>ActionController::Base</tt>.
module Turbo::Frames::FrameRequest
  extend ActiveSupport::Concern

  included do
    before_action -> { request.variant.push :turbo_frame }, if: :turbo_frame_request?
  end

  private
    def turbo_frame_request?
      request.headers["Turbo-Frame"].present?
    end
end
