require "test_helper"

class TestChannel < ApplicationCable::Channel; end

class Turbo::StreamsHelperTest < ActionView::TestCase
  class Component
    include ActiveModel::Model

    attr_accessor :id, :content

    def render_in(view_context)
      content
    end

    def to_key
      [id]
    end
  end

  attr_accessor :formats

  test "turbo_stream builder captures block when called without :partial keyword" do
    rendered = turbo_stream.update "target_id" do
      tag.span "Hello, world"
    end

    assert_dom_equal <<~HTML.strip, rendered
      <turbo-stream action="update" target="target_id">
        <template>
          <span>Hello, world</span>
        </template>
      </turbo-stream>
    HTML
  end

  test "turbo_stream builder forwards block to partial when called with :partial keyword" do
    rendered = turbo_stream.update "target_id", partial: "application/partial_with_block" do
      "Hello, from application/partial_with_block partial"
    end

    assert_dom_equal <<~HTML.strip, rendered
      <turbo-stream action="update" target="target_id">
        <template>
          <p>Hello, from application/partial_with_block partial</p>
        </template>
      </turbo-stream>
    HTML
  end

  test "turbo_stream builder forwards block to partial when called with :layout keyword" do
    rendered = turbo_stream.update "target_id", layout: "application/partial_with_block" do
      "Hello, from application/partial_with_block partial"
    end

    assert_dom_equal <<~HTML.strip, rendered
      <turbo-stream action="update" target="target_id">
        <template>
          <p>Hello, from application/partial_with_block partial</p>
        </template>
      </turbo-stream>
    HTML
  end

  test "supports valid :renderable option object with nil content" do
    component = Component.new(id: 1, content: "Hello, world")

    assert_dom_equal <<~HTML.strip, turbo_stream.update(component)
      <turbo-stream action="update" target="streams_helper_test_component_1"><template>Hello, world</template></turbo-stream>
    HTML
  end

  test "supports valid :renderable option object with content" do
    component = Component.new(id: 1, content: "Hello, world")

    assert_dom_equal <<~HTML.strip, turbo_stream.update(component, "Raw content")
      <turbo-stream action="update" target="streams_helper_test_component_1"><template>Raw content</template></turbo-stream>
    HTML
  end

  test "with streamable" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}"></turbo-cable-stream-source>),
      turbo_stream_from("messages")
  end

  test "with multiple streamables, some blank" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name(["channel", nil, "", "messages"])}"></turbo-cable-stream-source>),
      turbo_stream_from("channel", nil, "", "messages")
  end

  test "with invalid streamables" do
    assert_raises ArgumentError, "streamables can't be blank" do
      turbo_stream_from("")
    end

    assert_raises ArgumentError, "streamables can't be blank" do
      turbo_stream_from(nil)
    end

    assert_raises ArgumentError, "streamables can't be blank" do
      turbo_stream_from("", nil)
    end
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

  test "turbo_stream.refresh" do
    assert_dom_equal <<~HTML, turbo_stream.refresh
      <turbo-stream action="refresh"></turbo-stream>
    HTML
    assert_dom_equal <<~HTML, Turbo.with_request_id("abc123") { turbo_stream.refresh }
      <turbo-stream request-id="abc123" action="refresh"></turbo-stream>
    HTML
    assert_dom_equal <<~HTML, turbo_stream.refresh(request_id: "def456")
      <turbo-stream request-id="def456" action="refresh"></turbo-stream>
    HTML
  end

  test "custom turbo_stream builder actions" do
    assert_dom_equal <<~HTML.strip, turbo_stream.highlight("an-id")
      <turbo-stream action="highlight" target="an-id"><template></template></turbo-stream>
    HTML
    assert_dom_equal <<~HTML.strip, turbo_stream.highlight_all(".a-selector")
      <turbo-stream action="highlight" targets=".a-selector"><template></template></turbo-stream>
    HTML
  end

  test "custom turbo_stream builder action without target" do
    assert_dom_equal <<~HTML.strip, turbo_stream.redirect_to("/dashboard")
      <turbo-stream redirect_to="/dashboard" action="redirect_to"><template></template></turbo-stream>
    HTML
  end

  test "custom turbo_stream builder action with target and attributes" do
    assert_dom_equal <<~HTML.strip, turbo_stream.flash("flash-container", type: "success")
      <turbo-stream type="success" action="flash" target="flash-container"><template></template></turbo-stream>
    HTML
  end

  test "custom turbo_stream builder action_all with targets and attributes" do
    assert_dom_equal <<~HTML.strip, turbo_stream.flash_all(".flash-items", type: "warning")
      <turbo-stream type="warning" action="flash" targets=".flash-items"><template></template></turbo-stream>
    HTML
  end

  test "action method with optional target" do
    # Call action directly without a target
    assert_dom_equal <<~HTML.strip, turbo_stream.action(:custom_action, attributes: { data_url: "/path" })
      <turbo-stream data_url="/path" action="custom_action"><template></template></turbo-stream>
    HTML
  end

  test "action method with target and attributes" do
    assert_dom_equal <<~HTML.strip, turbo_stream.action(:custom, "my-target", attributes: { custom_attr: "value" })
      <turbo-stream custom_attr="value" action="custom" target="my-target"><template></template></turbo-stream>
    HTML
  end

  test "action_all method with optional targets" do
    # Call action_all directly without targets
    assert_dom_equal <<~HTML.strip, turbo_stream.action_all(:broadcast, attributes: { channel: "updates" })
      <turbo-stream channel="updates" action="broadcast"><template></template></turbo-stream>
    HTML
  end

  test "action_all method with targets and attributes" do
    assert_dom_equal <<~HTML.strip, turbo_stream.action_all(:notify, ".listeners", attributes: { priority: "high" })
      <turbo-stream priority="high" action="notify" targets=".listeners"><template></template></turbo-stream>
    HTML
  end

  test "supports valid :partial option objects" do
    message = Message.new(id: 1, content: "Hello, world")

    assert_dom_equal <<~HTML.strip, turbo_stream.update(message)
      <turbo-stream action="update" target="message_1"><template><p>Hello, world</p></template></turbo-stream>
    HTML
  end
end
