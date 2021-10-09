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

    assert_broadcast_on "stream", turbo_stream_action_tag("remove", targets: ".message") do
      Turbo::StreamsChannel.broadcast_remove_to "stream", targets: ".message"
    end
  end

  test "broadcasting remove now with record" do
    assert_broadcast_on "stream", turbo_stream_action_tag("remove", target: "message_1") do
      Turbo::StreamsChannel.broadcast_remove_to "stream", target: Message.new(id: 1, content: "hello!")
    end
  end

  test "broadcasting replace now" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: render(options)) do
      Turbo::StreamsChannel.broadcast_replace_to "stream", target: "message_1", **options
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("replace", targets: ".message", template: render(options)) do
      Turbo::StreamsChannel.broadcast_replace_to "stream", targets: ".message", **options
    end
  end

  test "broadcasting update now" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("update", target: "message_1", template: render(options)) do
      Turbo::StreamsChannel.broadcast_update_to "stream", target: "message_1", **options
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("update", targets: ".message", template: render(options)) do
      Turbo::StreamsChannel.broadcast_update_to "stream", targets: ".message", **options
    end
  end

  test "broadcasting append now" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("append", target: "messages", template: render(options)) do
      Turbo::StreamsChannel.broadcast_append_to "stream", target: "messages", **options
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("append", targets: ".message", template: render(options)) do
      Turbo::StreamsChannel.broadcast_append_to "stream", targets: ".message", **options
    end
  end

  test "broadcasting append now with empty template" do
    assert_broadcast_on "stream", %(<turbo-stream action="append" target="message_1"><template></template></turbo-stream>) do
      Turbo::StreamsChannel.broadcast_append_to "stream", target: "message_1", content: ""
    end
  end

  test "broadcasting prepend now" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: render(options)) do
      Turbo::StreamsChannel.broadcast_prepend_to "stream", target: "messages", **options
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", targets: ".message", template: render(options)) do
      Turbo::StreamsChannel.broadcast_prepend_to "stream", targets: ".message", **options
    end
  end

  test "broadcasting action now" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: render(options)) do
      Turbo::StreamsChannel.broadcast_action_to "stream", action: "prepend", target: "messages", **options
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", targets: ".message", template: render(options)) do
      Turbo::StreamsChannel.broadcast_action_to "stream", action: "prepend", targets: ".message", **options
    end
  end

  test "broadcasting replace later" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_replace_later_to \
          "stream", target: "message_1", **options
      end
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("replace", targets: ".message", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_replace_later_to \
          "stream", targets: ".message", **options
      end
    end
  end

  test "broadcasting update later" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("update", target: "message_1", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_update_later_to \
          "stream", target: "message_1", **options
      end
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("update", targets: ".message", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_update_later_to \
          "stream", targets: ".message", **options
      end
    end
  end

  test "broadcasting append later" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("append", target: "messages", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_append_later_to \
          "stream", target: "messages", **options
      end
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("append", targets: ".message", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_append_later_to \
          "stream", targets: ".message", **options
      end
    end
  end

  test "broadcasting prepend later" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_prepend_later_to \
          "stream", target: "messages", **options
      end
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", targets: ".message", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_prepend_later_to \
          "stream", targets: ".message", **options
      end
    end

  end

  test "broadcasting action later" do
    options = { partial: "messages/message", locals: { message: "hello!" } }

    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_action_later_to \
          "stream", action: "prepend", target: "messages", **options
      end
    end

    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", targets: ".message", template: render(options)) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_action_later_to \
          "stream", action: "prepend", targets: ".message", **options
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
