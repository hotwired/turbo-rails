require "turbo_test"
require "action_cable"

class Turbo::StreamsChannelTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  test "verified stream name" do
    assert_equal "stream", Turbo::StreamsChannel.verified_stream_name(Turbo::StreamsChannel.signed_stream_name("stream"))
  end


  test "broadcasting remove now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("remove", target: "message_1") do
      Turbo::StreamsChannel.broadcast_remove_to "stream", target: "message_1"
    end
  end

  test "broadcasting remove now with record" do
    assert_broadcast_on "stream", turbo_stream_action_tag("remove", target: "message_1") do
      Turbo::StreamsChannel.broadcast_remove_to "stream", target: Message.new(record_id: 1, content: "hello!")
    end
  end

  test "broadcasting replace now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: "<p>hello!</p>") do
      Turbo::StreamsChannel.broadcast_replace_to "stream", target: "message_1", partial: "messages/message", locals: { message: "hello!" }
    end
  end

  test "broadcasting update now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("update", target: "message_1", template: "<p>hello!</p>") do
      Turbo::StreamsChannel.broadcast_update_to "stream", target: "message_1", partial: "messages/message", locals: { message: "hello!" }
    end
  end

  test "broadcasting append now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("append", target: "messages", template: "<p>hello!</p>") do
      Turbo::StreamsChannel.broadcast_append_to "stream", target: "messages", partial: "messages/message", locals: { message: "hello!" }
    end
  end

  test "broadcasting append now with empty template" do
    assert_broadcast_on "stream", %(<turbo-stream action="append" target="message_1"><template></template></turbo-stream>) do
      Turbo::StreamsChannel.broadcast_append_to "stream", target: "message_1", content: ""
    end
  end

  test "broadcasting prepend now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: "<p>hello!</p>") do
      Turbo::StreamsChannel.broadcast_prepend_to "stream", target: "messages", partial: "messages/message", locals: { message: "hello!" }
    end
  end

  test "broadcasting action now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: "<p>hello!</p>") do
      Turbo::StreamsChannel.broadcast_action_to "stream", action: "prepend", target: "messages", partial: "messages/message", locals: { message: "hello!" }
    end
  end


  test "broadcasting replace later" do
    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: "<p>hello!</p>") do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_replace_later_to \
          "stream", target: "message_1", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end

  test "broadcasting update later" do
    assert_broadcast_on "stream", turbo_stream_action_tag("update", target: "message_1", template: "<p>hello!</p>") do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_update_later_to \
          "stream", target: "message_1", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end

  test "broadcasting append later" do
    assert_broadcast_on "stream", turbo_stream_action_tag("append", target: "messages", template: "<p>hello!</p>") do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_append_later_to \
          "stream", target: "messages", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end

  test "broadcasting prepend later" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: "<p>hello!</p>") do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_prepend_later_to \
          "stream", target: "messages", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end

  test "broadcasting action later" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: "<p>hello!</p>") do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_action_later_to \
          "stream", action: "prepend", target: "messages", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end


  test "broadcasting render now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: "Goodbye!") do
      Turbo::StreamsChannel.broadcast_render_to "stream", partial: "messages/message"
    end
  end

  test "broadcasting render later" do
    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: "Goodbye!") do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_render_later_to "stream", partial: "messages/message"
      end
    end
  end

  test "broadcasting direct update now" do
    assert_broadcast_on "stream", %(direct) do
      Turbo::StreamsChannel.broadcast_stream_to "stream", content: "direct"
    end
  end
end
