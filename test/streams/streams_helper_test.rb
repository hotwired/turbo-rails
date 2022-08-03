require "test_helper"

class TestChannel < ApplicationCable::Channel; end

class Turbo::StreamsHelperTest < ActionView::TestCase
  test "with streamable" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}"></turbo-cable-stream-source>),
      turbo_stream_from("messages")
  end

  test "with streamable and html attributes" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}" data-stream-target="source"></turbo-cable-stream-source>),
      turbo_stream_from("messages", data: { stream_target: "source" })
  end

  test "with channel" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="NonExistentChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}"></turbo-cable-stream-source>),
      turbo_stream_from("messages", channel: "NonExistentChannel")
  end

  test "with channel as a class name" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="TestChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}"></turbo-cable-stream-source>),
      turbo_stream_from("messages", channel: TestChannel)
  end

  test "with channel and extra data" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="NonExistentChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}" data-payload="1"></turbo-cable-stream-source>),
      turbo_stream_from("messages", channel: "NonExistentChannel", data: {payload: 1})
  end

end
