require "turbo_test"

class Turbo::DriveHelperTest < ActionDispatch::IntegrationTest
  test "opting out of the default cache" do
    get trays_path
    assert_select "meta", name: "turbo-cache-control", content: "no-cache"
  end

  test "rendering template as html returns non-turbo mime type" do
    get trays_path, as: :turbo_stream
    refute_includes response.content_type, "turbo-stream"
  end
end
