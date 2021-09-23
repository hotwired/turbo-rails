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

  test "Users::Profile broadcasts Turbo Streams" do
    visit users_profiles_path

    assert_text "Users::Profiles"
    assert_broadcasts_text "Profile 1" do |text|
      Users::Profile.new(id: 1, name: text).broadcast_append_to(:users_profiles)
    end
  end

  private

    def assert_broadcasts_text(text, &block)
      assert_no_text text
      perform_enqueued_jobs { block.call(text) }
      assert_text text
    end
end
