require "test_helper"

class Turbo::FrameRequestControllerTest < ActionDispatch::IntegrationTest
  test "frame requests are rendered with a minimal layout" do
    get tray_path(id: 1)
    assert_select "title", count: 1

    get tray_path(id: 1), headers: { "Turbo-Frame" => "true" }
    assert_select "title", count: 0
  end

  test "frame request layout includes `head` content" do
    get tray_path(id: 1), headers: { "Turbo-Frame" => "true" }

    assert_select "head", count: 1
    assert_select "meta[name=test][content=present]"
  end

  test "frame request layout can be overridden" do
    with_prepended_view_path "test/frames/views" do
      get tray_path(id: 1), headers: { "Turbo-Frame" => "true" }
    end

    assert_select "meta[name=test][content=present]"
    assert_select "meta[name=alternative][content=present]"
  end

  test "frame requests get a unique etag" do
    get tray_path(id: 1)
    etag_without_frame = @response.headers["ETag"]

    get tray_path(id: 1), headers: { "Turbo-Frame" => "true" }
    etag_with_frame = @response.headers["ETag"]

    assert_not_equal etag_with_frame, etag_without_frame
  end

  test "turbo_frame_request_id returns the Turbo-Frame header value" do
    turbo_frame_request_id = "test_frame_id"

    get tray_path(id: 1)
    assert_no_match(/#{turbo_frame_request_id}/, @response.body)

    get tray_path(id: 1), headers: { "Turbo-Frame" => turbo_frame_request_id }
    assert_match(/#{turbo_frame_request_id}/, @response.body)
  end

  private
    def with_prepended_view_path(path, &block)
      previous_view_paths = ApplicationController.view_paths
      ApplicationController.prepend_view_path path
      yield
    ensure
      ApplicationController.view_paths = previous_view_paths
    end
end
