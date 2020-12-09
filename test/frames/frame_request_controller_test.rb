require "turbo_test"

class Turbo::FrameRequestControllerTest < ActionDispatch::IntegrationTest
  test "frame requests are rendered without a layout" do
    get tray_path(id: 1)
    assert_select "title", count: 1

    get tray_path(id: 1), headers: { "X-Turbo-Frame" => "true" }
    assert_select "title", count: 0
  end

  test "frame requests get a unique etag" do
    get tray_path(id: 1)
    etag_without_frame = @response.headers["ETag"]

    get tray_path(id: 1), headers: { "X-Turbo-Frame" => "true" }
    etag_with_frame = @response.headers["ETag"]

    assert_not_equal etag_with_frame, etag_without_frame
  end
end
