require "tag_builder_test_case"

class Turbo::Streams::TagBuilder::AppendTest < TagBuilderTestCase
  test "append with target and content as positional arguments" do
    stream_one = %(<turbo-stream action="append" target="messages"><template>Append</template></turbo-stream>)
    stream_all = %(<turbo-stream action="append" targets="messages"><template>Append</template></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.append("messages", "Append")
    assert_dom_equal stream_all, turbo_stream.append_all("messages", "Append")
  end

  test "append with target as arg and content as kwarg" do
    stream_one = %(<turbo-stream action="append" target="messages"><template>Append</template></turbo-stream>)
    stream_all = %(<turbo-stream action="append" targets="messages"><template>Append</template></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.append("messages", content: "Append")
    assert_dom_equal stream_all, turbo_stream.append_all("messages", content: "Append")
  end

  test "append with target and content as kwargs" do
    stream_one = %(<turbo-stream action="append" target="messages"><template>Append</template></turbo-stream>)
    stream_all = %(<turbo-stream action="append" targets="messages"><template>Append</template></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.append(target: "messages", content: "Append")
    assert_dom_equal stream_all, turbo_stream.append(targets: "messages", content: "Append")
  end

  test "append with target as arg and partial kwarg" do
    stream_one = %(<turbo-stream action="append" target="messages"><template><p>Append</p>
</template></turbo-stream>)
    stream_all = %(<turbo-stream action="append" targets="messages"><template><p>Append</p>
</template></turbo-stream>)

    article = Article.new(body: "Append")

    assert_dom_equal stream_one, turbo_stream.append("messages", partial: "articles/article", locals: { article: article })
    assert_dom_equal stream_all, turbo_stream.append_all("messages", partial: "articles/article", locals: { article: article })
  end
end
