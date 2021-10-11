require "application_system_test_case"

class UjsMethodTest < ApplicationSystemTestCase
  test "supports a[data-method]" do
    visit new_article_path

    click_on "Page: Post"

    assert_text "Default Article body"
  end
end
