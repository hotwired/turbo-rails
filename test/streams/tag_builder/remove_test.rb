require "tag_builder_test_case"

class Turbo::Streams::TagBuilder::RemoveTest < TagBuilderTestCase
  test "remove with target as positional argument" do
    stream_one = %(<turbo-stream action="remove" target="messages"></turbo-stream>)
    stream_all = %(<turbo-stream action="remove" targets="messages"></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.remove("messages")
    assert_dom_equal stream_all, turbo_stream.remove_all("messages")
  end
end
