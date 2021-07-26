# Turbo frame requests are requests made from within a turbo frame with the intention of replacing the content of just
# that frame, not the whole page. They are automatically tagged as such by the Turbo Frame JavaScript, which adds a
# <tt>Turbo-Frame</tt> header to the request. When that header is detected by the controller, we ensure that any
# template layout is skipped (since we're only working on an in-page frame, thus can skip the weight of the layout), and
# that the etag for the page is changed (such that a cache for a layout-less request isn't served on a normal request
# and vice versa).
#
# This is merely a rendering optimization. Everything would still work just fine if we rendered everything including the layout.
# Turbo Frames knows how to fish out the relevant frame regardless.
#
# This module is automatically included in <tt>ActionController::Base</tt>.
module Turbo::Frames::FrameRequest
  extend ActiveSupport::Concern

  included do
    layout -> { false if turbo_frame_request? }
    etag { :frame if turbo_frame_request? }
  end

  # Check for "Turbo-Frame" header in the response headers and if found
  # we wrap the response body with a turbo-frame tag with an id equal to
  # the "Turbo-Frame" header value.
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if status != 304 && headers["Turbo-Frame"].present?
        response = wrap_with_turbo_frame(response.body, headers["Turbo-Frame"])
        headers['Content-Length'] = response[0].bytesize.to_s
      end

      [status, headers, response]
    end

    private

      def wrap_with_turbo_frame(response_body, turbo_frame_id)
        ["<turbo-frame id='#{turbo_frame_id}'>#{response_body}</turbo-frame>"]
      end
  end

  # Determine if we should wrap the response body with the appropriate turbo-frame
  # tag and if so, we pass the "Turbo-Frame" header to the response to be caught
  # by Turbo::Frames::FrameRequest::Middleware.
  def render(*args)
    options = _normalize_render(*args)

    if should_wrap_response_body?(options)
      response.headers["Turbo-Frame"] = request.headers["Turbo-Frame"]
    end

    super
  end

  private
    def turbo_frame_request?
      request.headers["Turbo-Frame"].present?
    end

    # Determine if we should wrap the response body with a turbo-frame tag.
    # First check if this is a turbo frame request and return false if it's not.
    # Then, if no 'with_turbo_frame' option is passed as an option, return the
    # 'turbo_frame_auto_wrap_response_body' configuration value.
    # In we didn't return until now, we should return the 'with_turbo_frame' value.
    def should_wrap_response_body?(render_options)
      return false unless turbo_frame_request?
      return Rails.configuration.turbo_frame_auto_wrap_response_body if render_options[:with_turbo_frame].nil?
      return render_options[:with_turbo_frame]
    end
end
