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

  test "configuring refresh strategy" do
    get trays_path
    assert_match(/<meta name="turbo-refresh-method" content="morph">/, @response.body)
    assert_match(/<meta name="turbo-refresh-scroll" content="preserve">/, @response.body)
  end
end

class Turbo::DriverHelperUnitTest < ActionView::TestCase
  include Turbo::DriveHelper

  test "validate turbo refresh values" do
    assert_raises ArgumentError do
      turbo_refreshes_with(method: :invalid)
    end

    assert_raises ArgumentError do
      turbo_refreshes_with(scroll: :invalid)
    end
  end
end
