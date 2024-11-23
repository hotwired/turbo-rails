require "application_system_test_case"

class FramesTest < ApplicationSystemTestCase
  test "can render an invalid submission within a frame" do
    visit new_article_path
    toggle_disclosure "New Article" do
      click_on "Create Article"
    end

    within_disclosure "New Article" do
      assert_field "Body", with: ""
      assert_text "can't be blank"
    end
  end

  test "can redirect the entire page after a valid submission within a frame" do
    visit new_article_path
    toggle_disclosure "New Article" do
      fill_in "Body", with: "An article's body"
      click_on "Create Article"
    end

    assert_no_selector "details", text: "New Article"
    assert_no_field "Body"
    assert_text "An article's body"
    assert_selector "[role=alert]", text: "Created!"
  end

  def toggle_disclosure(locator, &block)
    find("details", text: locator).click
    within_disclosure(locator, &block)
  end

  def within_disclosure(locator, &block)
    within("details", text: locator, &block)
  end
end
