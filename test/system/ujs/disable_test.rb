require "application_system_test_case"

class UjsHTMLAnchorElementTest < ApplicationSystemTestCase
  test "supports with a[data-disable-with]" do
    visit new_message_path

    click_link "Page: Visit"

    assert_link "Page: Visiting"
    assert_link "Frame: Visit"
    assert_no_link "Page: Visiting"
    assert_text "Page: Visited"
  end

  test "supports a[data-turbo-frame][data-disable-with]" do
    visit new_message_path

    click_link "Frame: Visit"

    assert_link "Frame: Visiting"
    assert_link "Frame: Visit"
    assert_no_link "Frame: Visiting"
    assert_text "Frame: Visited"
  end
end

class UjsHTMLButtonElementTest < ApplicationSystemTestCase
  test "supports form[method=get] button[data-disable-with]" do
    visit new_message_path

    click_button "Page: Submit GET form button"

    assert_button "Page: Submitting GET form button", disabled: true
    assert_no_button "Page: Submitting GET form button"
    assert_button "Page: Submit GET form button"
    assert_text "Page: Submitted GET form button"
  end

  test "supports form[method=get][data-turbo-frame] button[data-disable-with]" do
    visit new_message_path

    click_button "Frame: Submit GET form[data-turbo-frame] button"

    assert_button "Frame: Submitting GET form[data-turbo-frame] button", disabled: true
    assert_no_button "Frame: Submitting GET form[data-turbo-frame] button"
    assert_button "Frame: Submit GET form[data-turbo-frame] button"
    assert_text "Frame: Submitted GET form[data-turbo-frame] button"
  end

  test "supports form[method=get] button[data-disable-with][data-turbo-frame]" do
    visit new_message_path

    click_button "Frame: Submit GET form button[data-turbo-frame]"

    assert_button "Frame: Submitting GET form button[data-turbo-frame]", disabled: true
    assert_no_button "Frame: Submitting GET form button[data-turbo-frame]"
    assert_button "Frame: Submit GET form button[data-turbo-frame]"
    assert_text "Frame: Submitted GET form button[data-turbo-frame]"
  end

  test "supports form[method=post] button[data-disable-with]" do
    visit new_message_path

    click_button "Submit POST form button"

    assert_button "Submitting POST form button", disabled: true
    assert_no_button "Submitting POST form button"
    assert_button "Submit POST form button"
  end

  test "supports form[method=post] button[data-turbo-frame][data-disable-with]" do
    visit new_message_path

    click_button "Submit POST form button[data-turbo-frame]"

    assert_button "Submitting POST form button[data-turbo-frame]", disabled: true
    assert_no_button "Submitting POST form button[data-turbo-frame]"
    assert_button "Submit POST form button[data-turbo-frame]"
  end

  test "supports form[method=post][data-turbo-frame] button[data-disable-with]" do
    visit new_message_path

    click_button "Submit POST form[data-turbo-frame] button"

    assert_button "Submitting POST form[data-turbo-frame] button", disabled: true
    assert_no_button "Submitting POST form[data-turbo-frame] button"
    assert_button "Submit POST form[data-turbo-frame] button"
  end
end

class UjsHTMLInputElementTest < ApplicationSystemTestCase
  test "supports form[method=get] input[data-disable-with]" do
    visit new_message_path

    click_button "Page: Submit GET form input"

    assert_button "Page: Submitting GET form input", disabled: true
    assert_no_button "Page: Submitting GET form input"
    assert_button "Page: Submit GET form input"
    assert_text "Page: Submitted GET form input"
  end

  test "supports form[method=get][data-turbo-frame] input[data-disable-with]" do
    visit new_message_path

    click_button "Frame: Submit GET form[data-turbo-frame] input"

    assert_button "Frame: Submitting GET form[data-turbo-frame] input", disabled: true
    assert_no_button "Frame: Submitting GET form[data-turbo-frame] input"
    assert_button "Frame: Submit GET form[data-turbo-frame] input"
    assert_text "Frame: Submitted GET form[data-turbo-frame] input"
  end

  test "supports form[method=get] input[data-disable-with][data-turbo-frame]" do
    visit new_message_path

    click_button "Frame: Submit GET form input[data-turbo-frame]"

    assert_button "Frame: Submitting GET form input[data-turbo-frame]", disabled: true
    assert_no_button "Frame: Submitting GET form input[data-turbo-frame]"
    assert_button "Frame: Submit GET form input[data-turbo-frame]"
    assert_text "Frame: Submitted GET form input[data-turbo-frame]"
  end

  test "supports form[method=post] input[data-disable-with]" do
    visit new_message_path

    click_button "Submit POST form input"

    assert_button "Submitting POST form input", disabled: true
    assert_no_button "Submitting POST form input"
    assert_button "Submit POST form input"
  end

  test "supports form[method=post] input[data-turbo-frame][data-disable-with]" do
    visit new_message_path

    click_button "Submit POST form input[data-turbo-frame]"

    assert_button "Submitting POST form input[data-turbo-frame]", disabled: true
    assert_no_button "Submitting POST form input[data-turbo-frame]"
    assert_button "Submit POST form input[data-turbo-frame]"
  end

  test "supports form[method=post][data-turbo-frame] input[data-disable-with]" do
    visit new_message_path

    click_button "Submit POST form[data-turbo-frame] input"

    assert_button "Submitting POST form[data-turbo-frame] input", disabled: true
    assert_no_button "Submitting POST form[data-turbo-frame] input"
    assert_button "Submit POST form[data-turbo-frame] input"
  end
end
