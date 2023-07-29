require "application_system_test_case"

class BroadcastsTest < ApplicationSystemTestCase
  test "Message broadcasts Turbo Streams" do
    visit messages_path
    wait_for_stream_to_be_connected

    assert_broadcasts_text "Message 1", to: :messages do |text, target|
      Message.create(content: text).broadcast_append_to(target)
    end
  end

  test "Message broadcasts with html: render option" do
    visit messages_path
    wait_for_stream_to_be_connected

    assert_broadcasts_text "Hello, with html: option", to: :messages do |text, target|
      Message.create(content: "Ignored").broadcast_append_to(target, html: text)
    end
  end

  test "Message broadcasts with renderable: render option" do
    visit messages_path
    wait_for_stream_to_be_connected

    assert_broadcasts_text "Test message", to: :messages do |text, target|
      Message.create(content: "Ignored").broadcast_append_to(target, renderable: MessageComponent.new(text))
    end
  end

  test "Does not render the layout twice when passed a component" do
    visit messages_path
    wait_for_stream_to_be_connected

    Message.create(content: "Ignored").broadcast_append_to(:messages, renderable: MessageComponent.new("test"))

    assert_selector("title", count: 1, visible: false, text: "Dummy")
  end

  test "Users::Profile broadcasts Turbo Streams" do
    visit users_profiles_path
    wait_for_stream_to_be_connected

    assert_broadcasts_text "Profile 1", to: :users_profiles do |text, target|
      Users::Profile.new(id: 1, name: text).broadcast_append_to(target)
    end
  end

  test "passing extra parameters to channel" do
    visit section_messages_path
    wait_for_stream_to_be_connected

    assert_broadcasts_text "In a section", to: :messages do |text|
      Message.create(content: text).broadcast_append_to(:important_messages)
    end
  end

  private

  def wait_for_stream_to_be_connected
    assert_selector "turbo-cable-stream-source[connected]", visible: false
  end

  def assert_broadcasts_text(text, to:, &block)
    within(:element, id: to) { assert_no_text text }

    [text, to].yield_self(&block)

    within(:element, id: to) { assert_text text }
  end
end
