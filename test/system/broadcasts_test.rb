require "application_system_test_case"

class BroadcastsTest < ApplicationSystemTestCase
  setup { Message.delete_all }

  test "Message broadcasts Turbo Streams" do
    visit messages_path

    assert_text "Messages"
    assert_broadcasts_text "Message 1" do |text|
      Message.create(content: text).broadcast_append_to(:messages)
    end
  end

  test "New messages update the message count with html" do
    visit messages_path

    assert_text "Messages"
    message = Message.create(content: "A new message")

    message.broadcast_update_to(:messages, target: "message-count",
      html: "#{Message.count} messages sent")
    assert_selector("#message-count", text: Message.count, wait: 10)
  end

  test "Users::Profile broadcasts Turbo Streams" do
    visit users_profiles_path

    assert_text "Users::Profiles"
    assert_broadcasts_text "Profile 1" do |text|
      Users::Profile.new(id: 1, name: text).broadcast_append_to(:users_profiles)
    end
  end

  private

    def assert_broadcasts_text(text, wait: 5, &block)
      assert_no_text text
      perform_enqueued_jobs { block.call(text) }
      assert_text text, wait: wait
    end
end
