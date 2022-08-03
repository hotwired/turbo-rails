require "application_system_test_case"

class BroadcastsTest < ApplicationSystemTestCase
  test "Message broadcasts Turbo Streams" do
    visit messages_path
    subscribe_to_broadcasts

    assert_broadcasts_text "Message 1", to: :messages do |text, target|
      Message.create(content: text).broadcast_append_to(target)
    end
  end

  test "Message broadcasts with html: render option" do
    visit messages_path
    subscribe_to_broadcasts

    assert_broadcasts_text "Hello, with html: option", to: :messages do |text, target|
      Message.create(content: "Ignored").broadcast_append_to(target, html: text)
    end
  end

  test "Users::Profile broadcasts Turbo Streams" do
    visit users_profiles_path
    subscribe_to_broadcasts

    assert_broadcasts_text "Profile 1", to: :users_profiles do |text, target|
      Users::Profile.new(id: 1, name: text).broadcast_append_to(target)
    end
  end

  test "passing extra parameters to channel" do
    visit echo_messages_path

    assert_broadcasts_text "Hello, world!", to: :messages do
      subscribe_to_broadcasts
    end
  end

  private

  def subscribe_to_broadcasts
    click_on "Start listening for broadcasts"

    assert_no_button "Start listening for broadcasts"

    Timeout.timeout(Capybara.default_max_wait_time) { wait_for_subscriber }
  end

  def assert_broadcasts_text(text, to:, &block)
    within(:element, id: to) { assert_no_text text }

    [text, to].yield_self(&block)

    within(:element, id: to) { assert_text text }
  end

  def wait_for_subscriber
    loop do
      subscriber_map = ActionCable.server.pubsub.instance_variable_get(:@subscriber_map)
      if subscriber_map.is_a?(ActionCable::SubscriptionAdapter::SubscriberMap)
        subscribers = subscriber_map.instance_variable_get(:@subscribers)
        sync = subscriber_map.instance_variable_get(:@sync)
        sync.synchronize do
          return unless subscribers.empty?
        end
      end
      sleep 0.1
    end
  end
end
