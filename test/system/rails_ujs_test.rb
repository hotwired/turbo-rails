require "application_system_test_case"

class RailsUjsTest < ApplicationSystemTestCase
  test "data-disable-with integration" do
    visit new_message_path

    click_on("Reload").then { assert_link "Reloading" }
    click_on("Submit").then { assert_button "Submitting", disabled: true }
    accept_confirm          { click_on("Confirm") }
  end
end
