require "application_system_test_case"

class UjsHTMLAnchorElementConfirmTest < ApplicationSystemTestCase
  test "supports a[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_link "Page: Visit Confirm" }

    assert_no_text "Page: Visited"

    accept_confirm("Are you sure?") { click_link "Page: Visit Confirm" }

    assert_text "Page: Visited"
  end

  test "supports a[data-confirm][data-turbo-frame]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_link "Frame: Visit Confirm" }

    assert_no_text "Frame: Visited"

    accept_confirm("Are you sure?") { click_link "Frame: Visit Confirm" }

    assert_text "Frame: Visited"
  end
end

class UjsHTMLButtonElementConfirmTest < ApplicationSystemTestCase
  test "supports GET button[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_button "Page: Confirm GET form button" }

    assert_no_text "Page: Confirmed GET form button"

    accept_confirm("Are you sure?") { click_button "Page: Confirm GET form button" }

    assert_text "Page: Confirmed GET form button"
  end

  test "supports GET form[data-turbo-frame] button[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_button "Frame: Confirm GET form[data-turbo-frame] button" }

    assert_no_text "Frame: Confirmed GET form[data-turbo-frame] button"

    accept_confirm("Are you sure?") { click_button "Frame: Confirm GET form[data-turbo-frame] button" }

    assert_text "Frame: Confirmed GET form[data-turbo-frame] button"
  end

  test "supports POST button[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_button "Page: Confirm POST form button" }
  end

  test "supports POST form[data-turbo-frame] button[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_button "Frame: Confirm POST form[data-turbo-frame] button" }
  end
end

class UjsHTMLInputElementConfirmTest < ApplicationSystemTestCase
  test "supports GET input[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_button "Page: Confirm GET form input" }

    assert_no_text "Page: Confirmed GET form input"

    accept_confirm("Are you sure?") { click_button "Page: Confirm GET form input" }

    assert_text "Page: Confirmed GET form input"
  end

  test "supports GET form[data-turbo-frame] input[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_button "Frame: Confirm GET form[data-turbo-frame] input" }

    assert_no_text "Frame: Confirmed GET form[data-turbo-frame] input"

    accept_confirm("Are you sure?") { click_button "Frame: Confirm GET form[data-turbo-frame] input" }

    assert_text "Frame: Confirmed GET form[data-turbo-frame] input"
  end

  test "supports POST input[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_button "Page: Confirm POST form input" }
  end

  test "supports POST form[data-turbo-frame] input[data-confirm]" do
    visit new_message_path

    dismiss_confirm("Are you sure?") { click_button "Frame: Confirm POST form[data-turbo-frame] input" }
  end
end
