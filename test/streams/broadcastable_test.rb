require "turbo_test"
require "action_cable"

class Turbo::BroadcastableTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  setup { @message = Message.new(record_id: 1, content: "Hello!") }

  test "broadcasting remove to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("remove", target: "message_1") do
      @message.broadcast_remove_to "stream"
    end
  end

  test "broadcasting remove now" do
    assert_broadcast_on "message:1", turbo_stream_action_tag("remove", target: "message_1") do
      @message.broadcast_remove
    end
  end

  test "broadcasting replace to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: "<p>Hello!</p>") do
      @message.broadcast_replace_to "stream"
    end
  end
end
