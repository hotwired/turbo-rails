require "turbo_test"

class Turbo::LinksHelperTest < ActionDispatch::IntegrationTest
  test "opting out of the default links cache" do
    get trays_path
    assert_select "meta", name: "turbolinks-cache-control", content: "no-cache"
  end
end
