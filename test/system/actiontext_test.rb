require "application_system_test_case"

class ActionTextTest < ApplicationSystemTestCase
  setup { skip if Rails.version < "7.1" }

  test "forwards [data-turbo-permanent] from trix-editor to its input and trix-toolbar" do
    visit new_message_path

    assert_trix_editor name: "message[content]", "data-turbo-permanent": true

    find(:rich_text_area).execute_script <<~JS
      this.removeAttribute("data-turbo-permanent")
    JS

    assert_trix_editor name: "message[content]", "data-turbo-permanent": false
  end

  test "keeps a trix-editor[data-turbo-permanent] interactive through a Page Refresh" do
    visit new_message_path(method: "morph")
    fill_in_rich_text_area with: "Hello"
    click_link "Page Refresh"

    assert_trix_editor name: "message[content]", with: /Hello/

    fill_in_rich_text_area with: "Hello world"

    assert_trix_editor name: "message[content]", with: /Hello world/
  end

  def assert_trix_editor(name: nil, with: nil, **options, &block)
    trix_editor = find(:element, "trix-editor", **options, &block)

    assert_field name, type: "hidden", with: with do |input|
      assert_equal trix_editor.evaluate_script("this.inputElement"), input
      assert_matches_selector input, :element, **options
    end
  end
end
