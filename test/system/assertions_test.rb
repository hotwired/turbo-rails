require "application_system_test_case"

class AssertionsTest < ApplicationSystemTestCase
  test "#assert_turbo_cable_stream_source treats the locator as :signed_stream_name filter" do
    message = Message.create!

    visit message_path(message)

    assert_turbo_cable_stream_source message, count: 1
    assert_no_turbo_cable_stream_source "junk"
  end

  test "#assert_turbo_cable_stream_source supports String collection filters" do
    visit messages_path

    assert_turbo_cable_stream_source connected: true, count: 1
    assert_turbo_cable_stream_source channel: Turbo::StreamsChannel, count: 1
    assert_turbo_cable_stream_source signed_stream_name: Turbo::StreamsChannel.signed_stream_name("messages"), count: 1
    assert_no_turbo_cable_stream_source connected: false
    assert_no_turbo_cable_stream_source channel: "junk"
    assert_no_turbo_cable_stream_source signed_stream_name: Turbo::StreamsChannel.signed_stream_name("junk")
  end

  test "#assert_turbo_cable_stream_source supports record filters" do
    message = Message.create!

    visit message_path(message)

    assert_turbo_cable_stream_source signed_stream_name: message
    assert_turbo_cable_stream_source signed_stream_name: [message]
    assert_turbo_cable_stream_source signed_stream_name: Turbo::StreamsChannel.signed_stream_name(message)
    assert_no_turbo_cable_stream_source signed_stream_name: [message, :junk]
  end
end
