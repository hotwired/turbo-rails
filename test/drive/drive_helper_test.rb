require "turbo_test"

class Turbo::DriveHelperTest < ActionDispatch::IntegrationTest
  test "opting out of the default cache" do
    get trays_path
    assert_match(/<meta name="turbo-cache-control" content="no-cache">/, @response.body)
  end
end
