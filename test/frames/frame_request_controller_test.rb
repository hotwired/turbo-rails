require "turbo_test"

class Turbo::FrameRequestControllerTest < ActionDispatch::IntegrationTest
  test "frame requests are rendered without a layout" do
    get tray_path(id: 1)
    assert_select "title", count: 1

    get tray_path(id: 1), headers: { "Turbo-Frame" => "true" }
    assert_select "title", count: 0
  end

  test "frame requests get a unique etag" do
    get tray_path(id: 1)
    etag_without_frame = @response.headers["ETag"]

    get tray_path(id: 1), headers: { "Turbo-Frame" => "true" }
    etag_with_frame = @response.headers["ETag"]

    assert_not_equal etag_with_frame, etag_without_frame
  end

  test "frame requests are rendered with a turbo-frame tag" do
    get tray_path(id: 1), headers: { "Turbo-Frame" => "tray" }
    assert_select "turbo-frame", { count: 1 }
  end

  test "response body gets wrapped with a turbo frame tag if 'with_turbo_frame: true' is provided" do
    get new_tray_path, headers: { "Turbo-Frame" => "new_tray" }
    assert_select "turbo-frame", { count: 1 }
    assert_select "turbo-frame#new_tray", { count: 1 }

    get part_two_tray_path(id: 1), headers: { "Turbo-Frame" => "partial_tray" }
    assert_select "turbo-frame", { count: 1 }
    assert_select "turbo-frame#partial_tray", { count: 1 }
  end

  test "response body doesn't get wrapped with a turbo frame tag if 'with_turbo_frame' is false" do
    get part_three_tray_path(id: 1), headers: { "Turbo-Frame" => "partial_tray" }
    assert_select "turbo-frame", { count: 0 }
  end

  test "response body gets wrapped with a turbo frame tag if the `turbo_frame_auto_wrap_response_body` is true" do
    Rails.configuration.turbo_frame_auto_wrap_response_body = true
    get part_one_tray_path(id: 1), headers: { "Turbo-Frame" => "partial_tray" }
    assert_select "turbo-frame", { count: 1 }
    assert_select "turbo-frame#partial_tray", { count: 1 }
    Rails.configuration.turbo_frame_auto_wrap_response_body = false
  end
end
