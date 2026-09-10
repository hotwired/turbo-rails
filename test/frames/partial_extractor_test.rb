require "test_helper"

class Turbo::PartialExtractorTest < ActiveSupport::TestCase
  include ActionViewTestCaseExtensions

  FIXTURES_DIR = Rails.root.join("app/views/partial_extractor_spec")

  setup do
    FileUtils.mkdir_p(FIXTURES_DIR)
  end

  teardown do
    FileUtils.rm_rf(FIXTURES_DIR)
    Rails.cache.delete("turbo_generated_partial/partial_extractor_spec/widget")
    Rails.cache.delete("turbo_generated_partial/partial_extractor_spec/leaky")
  end

  test "a turbo_frame_tag(partial:) block renders standalone via render(partial:), once its defining page has rendered" do
    write_fixture "host.html.erb", <<~ERB
      <% greeting = "hello" %>
      <%= turbo_frame_tag "widget", partial: "partial_extractor_spec/widget", locals: { greeting: greeting } do %>
        <p><%= greeting %></p>
      <% end %>
    ERB

    render template: "partial_extractor_spec/host"

    standalone = render(partial: "partial_extractor_spec/widget", locals: { greeting: "again" })
    assert_match "again", standalone
    assert_match "<turbo-frame", standalone
  end

  test "a block referencing an outer local not passed via locals: raises LocalsError, at extraction time" do
    write_fixture "leaky_host.html.erb", <<~ERB
      <% outer = "leaked" %>
      <%= turbo_frame_tag "leaky", partial: "partial_extractor_spec/leaky", locals: {} do %>
        <p><%= outer %></p>
      <% end %>
    ERB

    error = assert_raises(ActionView::Template::Error) do
      render template: "partial_extractor_spec/leaky_host"
    end
    assert_kind_of Turbo::PartialExtractor::LocalsError, error.cause
    assert_match "outer", error.cause.message
    assert_match "locals:", error.cause.message
  end

  private
    def write_fixture(name, content)
      File.write(FIXTURES_DIR.join(name), content)
    end
end
