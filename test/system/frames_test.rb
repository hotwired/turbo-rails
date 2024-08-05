require "application_system_test_case"

class FramesTest < ApplicationSystemTestCase
  test "can render an invalid submission within a frame" do
    visit new_article_path
    toggle_disclosure "New Article" do
      click_on "Create Article"
    end

    within_disclosure "New Article" do
      assert_field "Body", described_by: "can't be blank"
    end
  end

  test "can redirect the entire page after a valid submission within a frame" do
    visit new_article_path
    toggle_disclosure "New Article" do
      fill_in "Body", with: "An article's body"
      click_on "Create Article"
    end

    assert_no_selector :disclosure, "New Article"
    assert_no_field "Body"
    assert_text "An article's body"
  end
end
