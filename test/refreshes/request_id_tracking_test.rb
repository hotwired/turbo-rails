require "test_helper"

class Turbo::RequestIdTrackingTest < ActionDispatch::IntegrationTest
  test "set the current turbo request id from the value in the X-Turbo-Request-Id header" do
    get request_id_path, headers: { "X-Turbo-Request-Id" => "123" }
    assert_equal "123", JSON.parse(response.body)["turbo_frame_request_id"]
  end
end
