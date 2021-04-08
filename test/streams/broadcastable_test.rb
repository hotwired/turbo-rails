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
    assert_broadcast_on @message.to_param, turbo_stream_action_tag("remove", target: "message_1") do
      @message.broadcast_remove
    end
  end

  test "broadcasting replace to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: "<p>Hello!</p>") do
      @message.broadcast_replace_to "stream"
    end
  end

  test "broadcasting replace now" do
    assert_broadcast_on @message.to_param, turbo_stream_action_tag("replace", target: "message_1", template: "<p>Hello!</p>") do
      @message.broadcast_replace
    end
  end

  test "broadcasting append to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("append", target: "messages", template: "<p>Hello!</p>") do
      @message.broadcast_append_to "stream"
    end
  end

  test "broadcasting append to stream with custom target now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("append", target: "board_messages", template: "<p>Hello!</p>") do
      @message.broadcast_append_to "stream", target: "board_messages"
    end
  end

  test "broadcasting append now" do
    assert_broadcast_on @message.to_param, turbo_stream_action_tag("append", target: "messages", template: "<p>Hello!</p>") do
      @message.broadcast_append
    end
  end

  test "broadcasting prepend to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: "<p>Hello!</p>") do
      @message.broadcast_prepend_to "stream"
    end
  end

  test "broadcasting prepend to stream with custom target now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "board_messages", template: "<p>Hello!</p>") do
      @message.broadcast_prepend_to "stream", target: "board_messages"
    end
  end

  test "broadcasting prepend now" do
    assert_broadcast_on @message.to_param, turbo_stream_action_tag("prepend", target: "messages", template: "<p>Hello!</p>") do
      @message.broadcast_prepend
    end
  end

  test "broadcasting action to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: "<p>Hello!</p>") do
      @message.broadcast_action_to "stream", action: "prepend"
    end
  end

  test "broadcasting action now" do
    assert_broadcast_on @message.to_param, turbo_stream_action_tag("prepend", target: "messages", template: "<p>Hello!</p>") do
      @message.broadcast_action "prepend"
    end
  end

  test "render correct local name in partial for namespaced models" do
    @profile = Users::Profile.new(id: 1, name: "Ryan")
    assert_broadcast_on @profile.to_param, turbo_stream_action_tag("replace", target: "users_profile_1", template: "<p>Ryan</p>\n") do
      @profile.broadcast_replace
    end
  end
end
