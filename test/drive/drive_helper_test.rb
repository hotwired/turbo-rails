require "test_helper"

class Turbo::DriveHelperTest < ActionDispatch::IntegrationTest
  test "opting out of the default cache" do
    get trays_path
    assert_match(/<meta name="turbo-cache-control" content="no-cache">/, @response.body)
  end

  test "requiring reload" do
    get trays_path
    assert_match(/<meta name="turbo-visit-control" content="reload">/, @response.body)
  end
end
