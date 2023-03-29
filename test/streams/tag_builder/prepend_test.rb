require "tag_builder_test_case"

class Turbo::Streams::TagBuilder::PrependTest < TagBuilderTestCase
  test "prepend with target and content as positional arguments" do
    stream_one = %(<turbo-stream action="prepend" target="messages"><template>Prepend</template></turbo-stream>)
    stream_all = %(<turbo-stream action="prepend" targets="messages"><template>Prepend</template></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.prepend("messages", "Prepend")
    assert_dom_equal stream_all, turbo_stream.prepend_all("messages", "Prepend")
  end

  test "prepend with target as arg and content as kwarg" do
    stream_one = %(<turbo-stream action="prepend" target="messages"><template>Prepend</template></turbo-stream>)
    stream_all = %(<turbo-stream action="prepend" targets="messages"><template>Prepend</template></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.prepend("messages", content: "Prepend")
    assert_dom_equal stream_all, turbo_stream.prepend_all("messages", content: "Prepend")
  end

  test "prepend with target and content as kwarg" do
    stream_one = %(<turbo-stream action="prepend" target="messages"><template>Prepend</template></turbo-stream>)
    stream_all = %(<turbo-stream action="prepend" targets="messages"><template>Prepend</template></turbo-stream>)

    assert_dom_equal stream_one, turbo_stream.prepend(target: "messages", content: "Prepend")
    assert_dom_equal stream_all, turbo_stream.prepend(targets: "messages", content: "Prepend")
  end

  test "prepend with target as arg and partial kwarg" do
    stream_one = %(<turbo-stream action="prepend" target="messages"><template><p>Prepend</p>
</template></turbo-stream>)
    stream_all = %(<turbo-stream action="prepend" targets="messages"><template><p>Prepend</p>
</template></turbo-stream>)

    article = Article.new(body: "Prepend")

    assert_dom_equal stream_one, turbo_stream.prepend("messages", partial: "articles/article", locals: { article: article })
    assert_dom_equal stream_all, turbo_stream.prepend_all("messages", partial: "articles/article", locals: { article: article })
  end
end
