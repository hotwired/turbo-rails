require "turbo_test"

class Turbo::StreamsControllerTest < ActionDispatch::IntegrationTest
  test "create with respond to" do
    post messages_path
    assert_redirected_to message_path(id: 1)

    post messages_path, as: :turbo_stream
    assert_response :ok
    assert_turbo_stream action: :append, target: "messages" do |selected|
      assert_equal "<template>message_1</template>", selected.children.to_html
    end
  end

  test "show all turbo actions" do
    get message_path(id: 1), as: :turbo_stream
    assert_equal <<-STREAM, @response.body
<turbo-stream action="remove" target="message_1"></turbo-stream>
<turbo-stream action="replace" target="message_1"><template><p>My message</p></template></turbo-stream>
<turbo-stream action="replace" target="message_1"><template>Something else</template></turbo-stream>
<turbo-stream action="replace" target="message_5"><template>Something fifth</template></turbo-stream>
<turbo-stream action="replace" target="message_5"><template><p>OLLA!</p></template></turbo-stream>
<turbo-stream action="append" target="messages"><template><p>My message</p></template></turbo-stream>
<turbo-stream action="append" target="messages"><template><p>OLLA!</p></template></turbo-stream>
<turbo-stream action="prepend" target="messages"><template><p>My message</p></template></turbo-stream>
<turbo-stream action="prepend" target="messages"><template><p>OLLA!</p></template></turbo-stream>
STREAM
  end

  test "includes html format when rendering turbo_stream actions" do
    assert_nothing_raised do
      post posts_path, as: :turbo_stream
      assert_equal <<-STREAM.chomp, @response.body
<turbo-stream action="update" target="form-area"><template>
  Form
</template></turbo-stream>
STREAM
    end
  end
end
