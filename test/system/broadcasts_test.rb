require "application_system_test_case"

class BroadcastsTest < ApplicationSystemTestCase
  setup { Message.delete_all }

  include ActionCable::TestHelper

  test "Message broadcasts Turbo Streams" do
    visit messages_path
    wait_for_subscriber

    assert_text "Messages"
    assert_broadcasts_text "Message 1" do |text|
      Message.create(content: text).broadcast_append_to(:messages)
    end
  end

  test "New messages update the message count with html" do
    visit messages_path
    wait_for_subscriber

    assert_text "Messages"
    message = Message.create(content: "A new message")

    message.broadcast_update_to(:messages, target: "message-count",
      html: "#{Message.count} messages sent")
    assert_selector("#message-count", text: Message.count, wait: 10)
  end

  test "Users::Profile broadcasts Turbo Streams" do
    visit users_profiles_path
    wait_for_subscriber

    assert_text "Users::Profiles"
    assert_broadcasts_text "Profile 1" do |text|
      Users::Profile.new(id: 1, name: text).broadcast_append_to(:users_profiles)
    end
  end

  test "passing extra parameters to channel" do
    visit echo_messages_path
    wait_for_subscriber

    assert_text "Hello, world!", wait: 100
  end

  private

  def assert_broadcasts_text(text, wait: 5, &block)
    assert_no_text text
    perform_enqueued_jobs { block.call(text) }
    assert_text text, wait: wait
  end

  def wait_for_subscriber(timeout: 10)
    time = Time.now
    loop do
      subscriber_map = pubsub_adapter.instance_variable_get(:@subscriber_map)
      if subscriber_map.is_a?(ActionCable::SubscriptionAdapter::SubscriberMap)
        subscribers = subscriber_map.instance_variable_get(:@subscribers)
        sync = subscriber_map.instance_variable_get(:@sync)
        sync.synchronize do
          return unless subscribers.empty?
        end
      end
      assert_operator(Time.now - time, :<, timeout, "subscriber waiting timed out")
      sleep 0.1
    end
  end

end
