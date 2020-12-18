require "turbo_test"
require "action_cable"

class Turbo::BroadcastableTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  setup { @message = Message.new(1) }

  test "broadcasting remove now" do
    assert_broadcast_on "message:1", turbo_stream_action_tag("remove", "message_1") do
      @message.broadcast_remove
    end
  end
end
