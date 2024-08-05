require "application_system_test_case"

class NavigationsTest < ApplicationSystemTestCase
  test "navigation updates Turbo Refresh meta tags" do
    visit page_path(:classic)

    within "head", visible: false do
      assert_selector :element, "meta", name: "turbo-refresh-method", content: "replace", visible: false, count: 1
      assert_selector :element, "meta", name: "turbo-refresh-scroll", content: "reset", visible: false, count: 1
    end

    click_link "Morph"

    within "head", visible: false do
      assert_selector :element, "meta", name: "turbo-refresh-method", content: "morph", visible: false, count: 1
      assert_selector :element, "meta", name: "turbo-refresh-scroll", content: "preserve", visible: false, count: 1
    end

    click_link "Classic"

    within "head", visible: false do
      assert_selector :element, "meta", name: "turbo-refresh-method", content: "replace", visible: false, count: 1
      assert_selector :element, "meta", name: "turbo-refresh-scroll", content: "reset", visible: false, count: 1
    end
  end
end
