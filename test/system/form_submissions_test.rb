require "application_system_test_case"

class FormSubmissionsTest < ApplicationSystemTestCase
  test "form submission [method=get]" do
    article = Article.create! body: "My article"

    visit edit_article_path(article.id)

    click_on "articles#index"
  end

  test "form submission method is encoded as _method" do
    article = Article.create! body: "My article"

    visit edit_article_path(article.id)
    click_on "Submit as DELETE"

    assert_text "Articles"
    assert_no_text "My article"
  end

  test "form submissions override _method when [formmethod] is present" do
    article = Article.create! body: "My article"

    visit edit_article_path(article.id)
    click_on "Submit as POST"

    assert_text "Articles"
    assert_text "My article", count: 2
  end

  test "form submissions do not override _method when [formmethod] is absent" do
    article = Article.create! body: "My article"

    visit edit_article_path(article.id)
    fill_in "Body", with: "My edit", fill_options: { clear: :backspace }
    click_on "Submit as PATCH"

    assert_text "Articles"
    assert_text "My edit", count: 1
    assert_no_text "My article"
  end
end
