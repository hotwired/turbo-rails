require "test_helper"

class Turbo::PartialExtractorTest < ActiveSupport::TestCase
  include ActionViewTestCaseExtensions

  FIXTURES_DIR = Rails.root.join("app/views/partial_extractor_spec")

  setup do
    FileUtils.mkdir_p(FIXTURES_DIR)
    Rails.cache.delete(Turbo::PartialExtractor::REGISTRY_KEY) # each test's hydrate_all! pass starts clean
  end

  teardown do
    FileUtils.rm_rf(FIXTURES_DIR)
    %w[widget leaky cold_widget job_widget collision_a renamed orphan].each do |name|
      Rails.cache.delete("turbo_generated_partial/partial_extractor_spec/#{name}")
    end
    Rails.cache.delete(Turbo::PartialExtractor::REGISTRY_KEY)
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

  test "hydrate_all! finds a turbo_frame_tag(partial:) definition and caches it, no render required first" do
    write_fixture "cold_host.html.erb", <<~ERB
      <%= turbo_frame_tag "cold", partial: "partial_extractor_spec/cold_widget", locals: {} do %>
        <p>never rendered inline before this</p>
      <% end %>
    ERB

    Turbo::PartialExtractor.hydrate_all!

    assert Rails.cache.exist?("turbo_generated_partial/partial_extractor_spec/cold_widget")
  end

  test "the generated partial renders correctly from a plain background job — no request, no view, no controller" do
    write_fixture "job_host.html.erb", <<~ERB
      <%= turbo_frame_tag "job", partial: "partial_extractor_spec/job_widget", locals: { label: "hello" } do %>
        <p><%= label %></p>
      <% end %>
    ERB
    Turbo::PartialExtractor.hydrate_all!

    job_class = Class.new(ApplicationJob) do
      def perform
        ApplicationController.render(partial: "partial_extractor_spec/job_widget", locals: { label: "from a job" })
      end
    end

    rendered = job_class.new.perform_now
    assert_match "from a job", rendered
    assert_match "<turbo-frame", rendered
  end

  test "the same partial name defined in two different files, in the same pass, raises CollisionError" do
    write_fixture "host_a.html.erb", <<~ERB
      <%= turbo_frame_tag "a", partial: "partial_extractor_spec/collision_a", locals: {} do %>
        <p>from A</p>
      <% end %>
    ERB
    write_fixture "host_b.html.erb", <<~ERB
      <%= turbo_frame_tag "a", partial: "partial_extractor_spec/collision_a", locals: {} do %>
        <p>from B</p>
      <% end %>
    ERB

    error = assert_raises(Turbo::PartialExtractor::CollisionError) do
      Turbo::PartialExtractor.hydrate_all!
    end
    assert_match "partial_extractor_spec/collision_a", error.message
    assert_match "one location", error.message
  end

  test "moving a definition from one file to another does NOT falsely raise CollisionError" do
    write_fixture "host.html.erb", <<~ERB
      <%= turbo_frame_tag "r", partial: "partial_extractor_spec/renamed", locals: {} do %>
        <p>original location</p>
      <% end %>
    ERB
    Turbo::PartialExtractor.hydrate_all!
    assert_match "original location", extracted_text("renamed")

    # "move" it: the old file no longer declares it, a new file does
    File.delete(FIXTURES_DIR.join("host.html.erb"))
    write_fixture "new_home.html.erb", <<~ERB
      <%= turbo_frame_tag "r", partial: "partial_extractor_spec/renamed", locals: {} do %>
        <p>new location</p>
      <% end %>
    ERB

    Turbo::PartialExtractor.hydrate_all! # must not raise
    assert_match "new location", extracted_text("renamed")
    assert_no_match(/original location/, extracted_text("renamed"))
  end

  test "deleting a definition outright (not moving it) evicts its cache entry instead of leaving it stale" do
    write_fixture "host.html.erb", <<~ERB
      <%= turbo_frame_tag "o", partial: "partial_extractor_spec/orphan", locals: {} do %>
        <p>will be deleted</p>
      <% end %>
    ERB
    Turbo::PartialExtractor.hydrate_all!
    assert Rails.cache.exist?("turbo_generated_partial/partial_extractor_spec/orphan")

    File.delete(FIXTURES_DIR.join("host.html.erb"))
    Turbo::PartialExtractor.hydrate_all!

    assert_not Rails.cache.exist?("turbo_generated_partial/partial_extractor_spec/orphan")
  end

  private
    def write_fixture(name, content)
      File.write(FIXTURES_DIR.join(name), content)
    end

    def extracted_text(name)
      Rails.cache.read("turbo_generated_partial/partial_extractor_spec/#{name}")
    end
end
