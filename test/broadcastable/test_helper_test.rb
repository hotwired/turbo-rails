require "test_helper"

class Turbo::Broadcastable::TestHelper::CaptureTurboStreamBroadcastsTest < ActiveSupport::TestCase
  include Turbo::Broadcastable::TestHelper

  test "#capture_turbo_stream_broadcasts returns <turbo-stream> elements broadcast on a stream name" do
    message = Message.new(id: 1)

    message.broadcast_replace_to "messages"
    message.broadcast_remove_to "messages"
    replace, remove, *rest = capture_turbo_stream_broadcasts "messages"

    assert_empty rest
    assert_equal "replace", replace["action"]
    assert_equal "remove", remove["action"]
    assert_not_empty replace.at("template").element_children
    assert_nil remove.at("template")
  end

  test "#capture_turbo_stream_broadcasts returns an empty Array when no broadcasts happened on a stream name" do
    assert_empty capture_turbo_stream_broadcasts("messages")
  end

  test "#capture_turbo_stream_broadcasts returns <turbo-stream> elements broadcast on a stream object" do
    message = Message.new(id: 1)

    message.broadcast_replace
    message.broadcast_remove
    replace, remove, *rest = capture_turbo_stream_broadcasts message

    assert_empty rest
    assert_equal "replace", replace["action"]
    assert_equal "remove", remove["action"]
    assert_not_empty replace.at("template").element_children
    assert_nil remove.at("template")
  end

  test "#capture_turbo_stream_broadcasts returns <turbo-stream> elements broadcast on an Array of stream objects" do
    message = Message.new(id: 1)

    message.broadcast_replace_to [message, :special]
    message.broadcast_remove_to [message, :special]
    replace, remove, *rest = capture_turbo_stream_broadcasts [message, :special]

    assert_empty rest
    assert_equal "replace", replace["action"]
    assert_equal "remove", remove["action"]
    assert_not_empty replace.at("template").element_children
    assert_nil remove.at("template")
  end

  test "#capture_turbo_stream_broadcasts returns <turbo-stream> elements broadcast on a stream name from a block" do
    message = Message.new(id: 1)

    replace, remove, *rest = capture_turbo_stream_broadcasts "messages" do
      message.broadcast_replace_to "messages"
      message.broadcast_remove_to "messages"
    end

    assert_equal "replace", replace["action"]
    assert_equal "remove", remove["action"]
    assert_empty rest
  end

  test "#capture_turbo_stream_broadcasts returns <turbo-stream> elements broadcast on a stream object from a block" do
    message = Message.new(id: 1)

    replace, remove, *rest = capture_turbo_stream_broadcasts message do
      message.broadcast_replace
      message.broadcast_remove
    end

    assert_empty rest
    assert_equal "replace", replace["action"]
    assert_equal "remove", remove["action"]
    assert_not_empty replace.at("template").element_children
    assert_nil remove.at("template")
  end

  test "#capture_turbo_stream_broadcasts returns <turbo-stream> elements broadcast on an Array of stream objects from a block" do
    message = Message.new(id: 1)

    replace, remove, *rest = capture_turbo_stream_broadcasts [message, :special] do
      message.broadcast_replace_to [message, :special]
      message.broadcast_remove_to [message, :special]
    end

    assert_empty rest
    assert_equal "replace", replace["action"]
    assert_equal "remove", remove["action"]
    assert_not_empty replace.at("template").element_children
    assert_nil remove.at("template")
  end

  test "#capture_turbo_stream_broadcasts returns an empty Array when no broadcasts happened on a stream name from a block" do
    streams = capture_turbo_stream_broadcasts "messages" do
      # no-op
    end

    assert_empty streams
  end
end

class Turbo::Broadcastable::TestHelper::AssertTurboStreamBroadcastsTest < ActiveSupport::TestCase
  include Turbo::Broadcastable::TestHelper

  test "#assert_turbo_stream_broadcasts passes when there is a broadcast" do
    message = Message.new(id: 1)

    message.broadcast_replace_to "messages"

    assert_turbo_stream_broadcasts "messages"
  end

  test "#assert_turbo_stream_broadcasts passes when there are multiple broadcasts" do
    message = Message.new(id: 1)

    message.broadcast_replace_to "messages"
    message.broadcast_remove_to "messages"

    assert_turbo_stream_broadcasts "messages"
  end

  test "#assert_turbo_stream_broadcasts fails when no broadcasts happened on a stream name" do
    assert_raises Minitest::Assertion do
      assert_turbo_stream_broadcasts "messages"
    end
  end

  test "#assert_turbo_stream_broadcasts with a count: optional fails when no broadcasts happened on a stream name" do
    singular_failure = assert_raises Minitest::Assertion do
      assert_turbo_stream_broadcasts "messages", count: 1
    end

    assert_includes singular_failure.message, %(1 Turbo Stream broadcast on "messages")

    plural_failure = assert_raises Minitest::Assertion do
      assert_turbo_stream_broadcasts "messages", count: 2
    end

    assert_includes plural_failure.message, %(2 Turbo Stream broadcasts on "messages")
  end

  test "#assert_turbo_stream_broadcasts passes when broadcast on a stream object" do
    message = Message.new(id: 1)

    message.broadcast_replace
    message.broadcast_remove

    assert_turbo_stream_broadcasts message, count: 2
  end

  test "#assert_turbo_stream_broadcasts passes when broadcast on an Array of stream objects" do
    message = Message.new(id: 1)

    message.broadcast_replace_to [message, :special]
    message.broadcast_remove_to [message, :special]

    assert_turbo_stream_broadcasts [message, :special], count: 2
  end

  test "#assert_turbo_stream_broadcasts with a count: option passes when broadcast on a stream name from a block" do
    message = Message.new(id: 1)

    assert_turbo_stream_broadcasts "messages", count: 2 do
      message.broadcast_replace_to "messages"
      message.broadcast_remove_to "messages"
    end
  end

  test "#assert_turbo_stream_broadcasts returns <turbo-stream> elements broadcast on a stream object from a block" do
    message = Message.new(id: 1)

    assert_turbo_stream_broadcasts message, count: 2 do
      message.broadcast_replace
      message.broadcast_remove
    end
  end

  test "#assert_turbo_stream_broadcasts returns <turbo-stream> elements broadcast on an Array of stream objects from a block" do
    message = Message.new(id: 1)

    assert_turbo_stream_broadcasts [message, :special], count: 2 do
      message.broadcast_replace_to [message, :special]
      message.broadcast_remove_to [message, :special]
    end
  end

  test "#assert_turbo_stream_broadcasts fails when no broadcasts happened on a stream name from a block" do
    assert_raises Minitest::Assertion do
      assert_turbo_stream_broadcasts "messages" do
        # no-op
      end
    end
  end
end

class Turbo::Broadcastable::TestHelper::AssertNoTurboStreamBroadcastsTest < ActiveSupport::TestCase
  include Turbo::Broadcastable::TestHelper

  test "#assert_no_turbo_stream_broadcasts asserts no broadcasts with a stream name" do
    assert_no_turbo_stream_broadcasts "messages"
  end

  test "#assert_no_turbo_stream_broadcasts asserts no broadcasts with a stream name from a block" do
    assert_no_turbo_stream_broadcasts "messages" do
      # no-op
    end
  end

  test "#assert_no_turbo_stream_broadcasts asserts no broadcasts with a stream object" do
    message = Message.new(id: 1)

    assert_no_turbo_stream_broadcasts message
  end

  test "#assert_no_turbo_stream_broadcasts asserts no broadcasts with a stream object from a block" do
    message = Message.new(id: 1)

    assert_no_turbo_stream_broadcasts message do
      # no-op
    end
  end

  test "#assert_no_turbo_stream_broadcasts fails when when a broadcast happened on a stream name" do
    message = Message.new(id: 1)

    assert_raises Minitest::Assertion do
      message.broadcast_remove_to "messages"

      assert_no_turbo_stream_broadcasts "messages"
    end
  end

  test "#assert_no_turbo_stream_broadcasts fails when when a broadcast happened on a stream name from a block" do
    message = Message.new(id: 1)

    assert_raises Minitest::Assertion do
      assert_no_turbo_stream_broadcasts "messages" do
        message.broadcast_remove_to "messages"
      end
    end
  end

  test "#assert_no_turbo_stream_broadcasts fails when when a broadcast happened on a stream object" do
    message = Message.new(id: 1)

    assert_raises Minitest::Assertion do
      message.broadcast_remove

      assert_no_turbo_stream_broadcasts message
    end
  end

  test "#assert_no_turbo_stream_broadcasts fails when when a broadcast happened on a stream object from a block" do
    message = Message.new(id: 1)

    assert_raises Minitest::Assertion do
      assert_no_turbo_stream_broadcasts message do
        message.broadcast_remove
      end
    end
  end
end
