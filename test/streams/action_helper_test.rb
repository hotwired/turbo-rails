require "test_helper"

class Turbo::ActionHelperTest < ActionCable::Channel::TestCase
  include Turbo::Streams::ActionHelper

  test "target responds to #to_key" do
    message = Message.new(id: 1)

    stream = "<turbo-stream action=\"append\" target=\"message_1\"><template></template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: message)
  end

  test "target passed as array of dom_id arguments" do
    message = Message.new(id: 1)

    stream = "<turbo-stream action=\"append\" target=\"special_message_1\"><template></template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: [message, :special])
  end

  test "no template" do
    stream = "<turbo-stream action=\"append\" target=\"message_1\"><template></template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1")
  end

  test "additional attributes" do
    stream = "<turbo-stream hello=\"world\" foo=\"bar\" action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", hello: "world", foo: "bar")
  end

  test "additional nil attributes" do
    stream = "<turbo-stream action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", hello: nil, foo: nil)
  end

  test "additional boolean attributes" do
    stream = "<turbo-stream checked=\"checked\" action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", checked: true)
  end

  test "additional dashed attributes" do
    stream = "<turbo-stream hello-world=\"foo\" action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", "hello-world": "foo")
  end

  # Note: The ActionView::Helpers::TagHelper doesn't convert underscored keys to dasherized attributes
  test "additional underscore attributes" do
    stream = "<turbo-stream hello_world=\"foo\" action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", hello_world: "foo")
  end

  test "additional data attributes" do
    stream = "<turbo-stream data-value=\"foo\" data-hello-world=\"bar\" action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", data: { value: "foo", hello_world: "bar"})
  end

  test "additional aria attributes" do
    stream = "<turbo-stream aria-label=\"foo\" aria-checked=\"true\" action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", aria: { label: "foo", checked: true })
  end

  test "additional class attribute" do
    stream = "<turbo-stream class=\"stream\" action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", class: "stream")
  end

  test "additional class conditional attribute" do
    stream = "<turbo-stream class=\"stream another-stream\" action=\"append\" target=\"message_1\"><template>Template</template></turbo-stream>"

    assert_equal stream, turbo_stream_action_tag("append", target: "message_1", template: "Template", class: { "stream": true, "another-stream": true, "no-stream": false })
  end

  test "renders if no 'target' and no 'targets' attributes are provided" do
    action = assert_nothing_raised { turbo_stream_action_tag("my_custom_action") }

    assert_equal "<turbo-stream action=\"my_custom_action\"><template></template></turbo-stream>", action
  end
end
