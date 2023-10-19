require "application_system_test_case"

class BroadcastsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

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

  test "Message broadcasts with extra attributes to turbo stream tag" do
    visit messages_path
    wait_for_stream_to_be_connected

    assert_broadcasts_text "Message 1", to: :messages do |text, target|
      Message.create(content: text).broadcast_action_to(target, action: :append, attributes: { "data-foo": "bar" })
    end
  end

  test "Message broadcasts with correct extra attributes to turbo stream tag" do
    visit messages_path
    wait_for_stream_to_be_connected

    assert_forwards_turbo_stream_tag_attribute attr_key: "data-foo", attr_value: "bar", to: :messages do |attr_key, attr_value, target|
      Message.create(content: text).broadcast_action_to(target, action: :test, attributes: { attr_key => attr_value })
    end
  end

  test "Message broadcasts with no rendering" do
    visit messages_path
    wait_for_stream_to_be_connected

    assert_forwards_turbo_stream_tag_attribute attr_key: "data-foo", attr_value: "bar", to: :messages do |attr_key, attr_value, target|
      Message.create(content: text).broadcast_action_to(target, action: :test, render: false, partial: "non_existant", attributes: { attr_key => attr_value })
    end
  end

  test "Message broadcasts later with extra attributes to turbo stream tag" do
    visit messages_path
    wait_for_stream_to_be_connected

    perform_enqueued_jobs do
      assert_broadcasts_text "Message 1", to: :messages do |text, target|
        Message.create(content: text).broadcast_action_later_to(target, action: :append, attributes: { "data-foo": "bar" })
      end
    end
  end


  test "Message broadcasts later with correct extra attributes to turbo stream tag" do
    visit messages_path
    wait_for_stream_to_be_connected

    perform_enqueued_jobs do
      assert_forwards_turbo_stream_tag_attribute attr_key: "data-foo", attr_value: "bar", to: :messages do |attr_key, attr_value, target|
        Message.create(content: text).broadcast_action_later_to(target, action: :test, attributes: { attr_key => attr_value })
      end
    end
  end

  test "Message broadcasts later with no rendering" do
    visit messages_path
    wait_for_stream_to_be_connected

    perform_enqueued_jobs do
      assert_forwards_turbo_stream_tag_attribute attr_key: "data-foo", attr_value: "bar", to: :messages do |attr_key, attr_value, target|
        Message.create(content: text).broadcast_action_to(target, action: :test, render: false, partial: "non_existant", attributes: { attr_key => attr_value })
      end
    end
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

  def assert_forwards_turbo_stream_tag_attribute(attr_key:, attr_value:, to:, &block)
    execute_script(<<~SCRIPT)
      Turbo.StreamActions.test = function () {
        const attribute = this.getAttribute('#{attr_key}')

        document.getElementById('#{to}').innerHTML = attribute
      }
    SCRIPT

    within(:element, id: to) { assert_no_text attr_value }

    [attr_key, attr_value, to].yield_self(&block)

    within(:element, id: to) { assert_text attr_value }
  end
end
