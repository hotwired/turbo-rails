require "turbo_test"

class Turbo::StreamsControllerTest < ActionDispatch::IntegrationTest
  test "create with respond to" do
    post messages_path
    assert_redirected_to message_path(id: 1)

    post messages_path, as: :turbo_stream
    assert_no_turbo_stream action: :update, target: "messages"
    assert_turbo_stream status: :created, action: :append, target: "messages" do |selected|
      assert_equal "<template>message_1</template>", selected.children.to_html
    end
  end

  test "show all turbo actions" do
    get message_path(id: 1), as: :turbo_stream
    assert_dom_equal <<~STREAM, @response.body
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

  test "update all turbo actions for multiple targets" do
    patch message_path(id: 1), as: :turbo_stream
    assert_dom_equal <<~STREAM, @response.body
      <turbo-stream action="remove" targets="message_1"></turbo-stream>
      <turbo-stream action="replace" targets="message_1"><template><p>My message</p></template></turbo-stream>
      <turbo-stream action="replace" targets="message_1"><template>Something else</template></turbo-stream>
      <turbo-stream action="replace" targets="message_5"><template>Something fifth</template></turbo-stream>
      <turbo-stream action="replace" targets="message_5"><template><p>OLLA!</p></template></turbo-stream>
      <turbo-stream action="append" targets="messages"><template><p>My message</p></template></turbo-stream>
      <turbo-stream action="append" targets="messages"><template><p>OLLA!</p></template></turbo-stream>
      <turbo-stream action="prepend" targets="messages"><template><p>My message</p></template></turbo-stream>
      <turbo-stream action="prepend" targets="messages"><template><p>OLLA!</p></template></turbo-stream>
    STREAM
  end

  test "includes html format when rendering turbo_stream actions" do
    post posts_path, as: :turbo_stream
    assert_dom_equal <<~STREAM.chomp, @response.body
      <turbo-stream action="update" target="form-area"><template>
        Form
      </template></turbo-stream>
    STREAM
  end

  test "render correct partial for namespaced models" do
    get users_profile_path(id: 1), as: :turbo_stream
    assert_dom_equal <<~HTML, @response.body.remove(/\n(?=<\/)/)
      <turbo-stream action="replace" target="users_profile_1"><template><p>David</p></template></turbo-stream>
      <turbo-stream action="update" target="users_profile_1"><template><p>David</p></template></turbo-stream>
    HTML
  end

  test "render correct partial and I18n with a custom view path in the controller" do
    get admin_company_path(id: 1), as: :turbo_stream
    assert_dom_equal <<~HTML, @response.body.remove(/\n(?=<\/)/)
      <turbo-stream action="replace" target="company_1"><template><p>Company:</p>
      <p>Basecamp</p></template></turbo-stream>
    HTML
  end
end
