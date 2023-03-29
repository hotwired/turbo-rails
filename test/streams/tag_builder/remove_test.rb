require "tag_builder_test_case"

class Turbo::Streams::TagBuilder::RemoveTest < TagBuilderTestCase
  test "remove with target as positional argument" do
    stream_one = %(<turbo-stream action="remove" target="messages"></turbo-stream>)
    stream_all = %(<turbo-stream action="remove" targets="messages"></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.remove("messages")
    assert_dom_equal stream_all, turbo_stream.remove_all("messages")
  end

  test "remove with target and content as kwarg" do
    stream_one = %(<turbo-stream action="remove" target="messages"></template></turbo-stream>)
    stream_all = %(<turbo-stream action="remove" targets="messages"></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.remove(target: "messages")
    assert_dom_equal stream_all, turbo_stream.remove(targets: "messages")
  end
end
