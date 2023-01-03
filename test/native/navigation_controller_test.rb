require "test_helper"

class Turbo::Native::NavigationControllerTest < ActionDispatch::IntegrationTest
  test "recede, resume, or refresh when native or redirect when not" do
    %w[ recede resume refresh ].each do |action|
      post trays_path, params: { return_to: "#{action}_or_redirect" }
      assert_redirected_to tray_path(id: 1)

      post trays_path, params: { return_to: "#{action}_or_redirect" }, headers: header_for_turbo_native_app
      assert_redirected_to send("turbo_#{action}_historical_location_url")
    end
  end

  test "recede, resume, or refresh when native or redirect back when not" do
    %w[ recede resume refresh ].each do |action|
      post trays_path, params: { return_to: "#{action}_or_redirect_back" }
      assert_redirected_to tray_path(id: 5)

      post trays_path, params: { return_to: "#{action}_or_redirect_back" }, headers: header_for_referer
      assert_redirected_to "/past_place"

      post trays_path, params: { return_to: "#{action}_or_redirect_back" }, headers: header_for_turbo_native_app.merge(header_for_referer)
      assert_redirected_to send("turbo_#{action}_historical_location_url")
    end
  end

  test "include options in URL when redirecting native app" do
    post trays_path, params: { return_to: "refresh_or_redirect_with_options" }
    assert_redirected_to tray_path(id: 5)

    post trays_path, params: { return_to: "refresh_or_redirect_with_options" }, headers: header_for_turbo_native_app
    assert_redirected_to send("turbo_refresh_historical_location_url", notice: "confirmed", custom: 123)
  end

  test "historical location url sends text/html" do
    get turbo_refresh_historical_location_url

    assert_response :ok
    assert_equal "text/html; charset=utf-8", response.content_type
  end

  private
    def header_for_turbo_native_app
      { "HTTP_USER_AGENT" => "MyApp iOS/3.0 Turbo Native (build 13; iPad Air 2); iOS 9.3" }
    end

    def header_for_referer
      { "HTTP_REFERER" => "/past_place" }
    end
end
