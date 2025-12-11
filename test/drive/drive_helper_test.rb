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

  test "enabling view transition" do
    get trays_path
    assert_match(/<meta name="view-transition" content="same-origin">/, @response.body)

    get trays_path, headers: { "HTTP_REFERER" => trays_url }
    assert_no_match(/<meta name="view-transition" content="same-origin">/, @response.body)
  end
end

class Turbo::DriverHelperUnitTest < ActionView::TestCase
  include Turbo::DriveHelper

  test "accepts valid Symbol and String method values" do
    [ :replace, "replace", :morph, "morph" ].each do |method|
      assert_dom_equal <<~HTML, turbo_refresh_method_tag(method)
        <meta name="turbo-refresh-method" content="#{method}">
      HTML
    end
  end

  test "accepts valid Symbol and String scroll values" do
    [ :reset, "reset", :preserve, "preserve" ].each do |scroll|
      assert_dom_equal <<~HTML, turbo_refresh_scroll_tag(scroll)
        <meta name="turbo-refresh-scroll" content="#{scroll}">
      HTML
    end
  end

  test "validate turbo refresh values" do
    assert_raises ArgumentError do
      turbo_refreshes_with(method: :invalid)
    end

    assert_raises ArgumentError do
      turbo_refreshes_with(scroll: :invalid)
    end
  end
end
