require "turbo_test"

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
end
