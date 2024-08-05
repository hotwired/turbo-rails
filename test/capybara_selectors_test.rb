require "test_helper"
require "turbo/system_test_helper"
require "capybara/minitest"

class Turbo::CapybaraSelectorTestCase < ActionView::TestCase
  include Capybara::Minitest::Assertions

  attr_accessor :page

  def render_html(html, **local_assigns)
    render(inline: html, locals: local_assigns)

    self.page = Capybara.string(rendered.to_s)
  end
end

class Turbo::TurboCableStreamSourceSelectorTest < Turbo::CapybaraSelectorTestCase
  test ":turbo_cable_stream_source matches signed-stream-name as a locator" do
    message = Message.new(id: 1)

    render_html <<~ERB, message: message
      <%= turbo_stream_from message %>
    ERB

    assert_selector :turbo_cable_stream_source, count: 1
    assert_selector :turbo_cable_stream_source, message, count: 1
    assert_selector :turbo_cable_stream_source, [message], count: 1
    assert_selector :turbo_cable_stream_source, Turbo::StreamsChannel.signed_stream_name(message), count: 1
  end

  test ":turbo_cable_stream_source matches signed-stream-name with :signed_stream_name filter" do
    message = Message.new(id: 1)

    render_html <<~ERB, message: message
      <%= turbo_stream_from message %>
    ERB

    assert_selector :turbo_cable_stream_source, count: 1
    assert_selector :turbo_cable_stream_source, signed_stream_name: message, count: 1
    assert_selector :turbo_cable_stream_source, signed_stream_name: [message], count: 1
    assert_selector :turbo_cable_stream_source, signed_stream_name: Turbo::StreamsChannel.signed_stream_name(message), count: 1
  end

  test ":turbo_cable_stream_source matches channel with :channel filter" do
    message = Message.new(id: 1)

    render_html <<~ERB, message: message
      <%= turbo_stream_from message %>
    ERB

    assert_selector :turbo_cable_stream_source, count: 1
    assert_selector :turbo_cable_stream_source, channel: true
    assert_selector :turbo_cable_stream_source, channel: Turbo::StreamsChannel
    assert_selector :turbo_cable_stream_source, channel: "Turbo::StreamsChannel"
  end

  test ":turbo_cable_stream_source does not match signed-stream-name as a locator" do
    message = Message.new(id: 1)

    render_html <<~ERB, message: Message.new(id: 2)
      <%= turbo_stream_from message %>
    ERB

    assert_no_selector :turbo_cable_stream_source, "junk", count: 1
    assert_no_selector :turbo_cable_stream_source, message, count: 1
    assert_no_selector :turbo_cable_stream_source, [message], count: 1
    assert_no_selector :turbo_cable_stream_source, Turbo::StreamsChannel.signed_stream_name(message), count: 1
  end

  test ":turbo_cable_stream_source does not match signed-stream-name with :signed_stream_name filter" do
    message = Message.new(id: 1)

    render_html <<~ERB, message: Message.new(id: 2)
      <%= turbo_stream_from message %>
    ERB

    assert_no_selector :turbo_cable_stream_source, signed_stream_name: "junk", count: 1
    assert_no_selector :turbo_cable_stream_source, signed_stream_name: message, count: 1
    assert_no_selector :turbo_cable_stream_source, signed_stream_name: [message], count: 1
    assert_no_selector :turbo_cable_stream_source, signed_stream_name: Turbo::StreamsChannel.signed_stream_name(message), count: 1
  end

  test ":turbo_cable_stream_source does not match channel with :channel filter" do
    message = Message.new(id: 1)

    render_html <<~ERB, message: message
      <%= turbo_stream_from message %>
    ERB

    assert_no_selector :turbo_cable_stream_source, channel: false
    assert_no_selector :turbo_cable_stream_source, channel: Object
    assert_no_selector :turbo_cable_stream_source, channel: "Object"
  end
end
