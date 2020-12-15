require "turbo_test"
require "action_cable"

ActionCable.server.config.logger = Logger.new(STDOUT) if ENV["VERBOSE"]

class Message
  def initialize(record_id)
    @record_id = record_id
  end

  def to_key
    [ @record_id ]
  end

  def model_name
    ActiveModel::Name.new(self.class)
  end
end

class Turbo::StreamsChannelTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper

  test "verified stream name" do
    assert_equal "stream", Turbo::StreamsChannel.verified_stream_name(Turbo::StreamsChannel.signed_stream_name("stream"))
  end


  test "broadcasting remove now" do
    assert_broadcast_on "stream", %(<template data-page-update="remove#message_1"></template>) do
      Turbo::StreamsChannel.broadcast_remove_to "stream", element: "message_1"
    end
  end

  test "broadcasting remove now with record" do
    assert_broadcast_on "stream", %(<template data-page-update="remove#message_1"></template>) do
      Turbo::StreamsChannel.broadcast_remove_to "stream", element: Message.new(1)
    end
  end

  test "broadcasting replace now" do
    assert_broadcast_on "stream", %(<template data-page-update="replace#message_1"><p>hello!</p></template>) do
      Turbo::StreamsChannel.broadcast_replace_to "stream", element: "message_1", partial: "messages/message", locals: { message: "hello!" }
    end
  end

  test "broadcasting append now" do
    assert_broadcast_on "stream", %(<template data-page-update="append#messages"><p>hello!</p></template>) do
      Turbo::StreamsChannel.broadcast_append_to "stream", container: "messages", partial: "messages/message", locals: { message: "hello!" }
    end
  end

  test "broadcasting prepend now" do
    assert_broadcast_on "stream", %(<template data-page-update="prepend#messages"><p>hello!</p></template>) do
      Turbo::StreamsChannel.broadcast_prepend_to "stream", container: "messages", partial: "messages/message", locals: { message: "hello!" }
    end
  end

  test "broadcasting command now" do
    assert_broadcast_on "stream", %(<template data-page-update="prepend#messages"><p>hello!</p></template>) do
      Turbo::StreamsChannel.broadcast_command_to "stream", command: "prepend", dom_id: "messages", partial: "messages/message", locals: { message: "hello!" }
    end
  end


  test "broadcasting replace later" do
    assert_broadcast_on "stream", %(<template data-page-update="replace#message_1"><p>hello!</p></template>) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_replace_later_to \
          "stream", element: "message_1", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end

  test "broadcasting append later" do
    assert_broadcast_on "stream", %(<template data-page-update="append#messages"><p>hello!</p></template>) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_append_later_to \
          "stream", container: "messages", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end

  test "broadcasting prepend later" do
    assert_broadcast_on "stream", %(<template data-page-update="prepend#messages"><p>hello!</p></template>) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_prepend_later_to \
          "stream", container: "messages", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end

  test "broadcasting command later" do
    assert_broadcast_on "stream", %(<template data-page-update="prepend#messages"><p>hello!</p></template>) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_command_later_to \
          "stream", command: "prepend", dom_id: "messages", partial: "messages/message", locals: { message: "hello!" }
      end
    end
  end


  test "broadcasting render now" do
    assert_broadcast_on "stream", %(<template data-page-update="replace#message_1">Goodbye!</template>) do
      Turbo::StreamsChannel.broadcast_render_to "stream", partial: "messages/message"
    end
  end

  test "broadcasting render later" do
    assert_broadcast_on "stream", %(<template data-page-update="replace#message_1">Goodbye!</template>) do
      perform_enqueued_jobs do
        Turbo::StreamsChannel.broadcast_render_later_to "stream", partial: "messages/message"
      end
    end
  end

  test "broadcasting update now" do
    assert_broadcast_on "stream", %(direct) do
      Turbo::StreamsChannel.broadcast_update_to "stream", content: "direct"
    end
  end
end