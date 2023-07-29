require "test_helper"

class Turbo::StreamsControllerTest < ActionDispatch::IntegrationTest
  test "create with respond to" do
    post messages_path
    assert_redirected_to message_path(id: 1)

    post messages_path, as: :turbo_stream
    assert_no_turbo_stream status: :created, action: :update, target: "messages"
    assert_turbo_stream status: :created, action: :append, target: "messages" do |selected|
      assert_equal "<template>message_1</template>", selected.children.to_html
    end
  end

  test "show all turbo actions" do
    message_1 = Message.new(id: 1, content: "My message")
    message_5 = Message.new(id: 5, content: "OLLA!")

    get message_path(id: 1), as: :turbo_stream

    assert_dom_equal <<~HTML, @response.body
      <turbo-stream action="remove" target="message_1"></turbo-stream>
      <turbo-stream action="replace" target="message_1"><template>#{render(message_1)}</template></turbo-stream>
      <turbo-stream action="replace" target="message_1"><template>Something else</template></turbo-stream>
      <turbo-stream action="replace" target="message_5"><template>Something fifth</template></turbo-stream>
      <turbo-stream action="replace" target="message_5"><template>#{render(message_5)}</template></turbo-stream>
      <turbo-stream action="append" target="messages"><template>#{render(message_1)}</template></turbo-stream>
      <turbo-stream action="append" target="messages"><template>#{render(message_5)}</template></turbo-stream>
      <turbo-stream action="prepend" target="messages"><template>#{render(message_1)}</template></turbo-stream>
      <turbo-stream action="prepend" target="messages"><template>#{render(message_5)}</template></turbo-stream>
    HTML
  end

  test "update all turbo actions for multiple targets" do
    message_1 = Message.new(id: 1, content: "My message")
    message_5 = Message.new(id: 5, content: "OLLA!")

    patch message_path(id: 1), as: :turbo_stream

    assert_turbo_stream action: :replace, count: 4
    assert_turbo_stream action: :replace, targets: "#message_4" do
      assert_select 'template', 'Something fourth'
    end
    assert_dom_equal <<~HTML, @response.body
      <turbo-stream action="remove" targets="#message_1"></turbo-stream>
      <turbo-stream action="replace" targets="#message_1"><template>#{render(message_1)}</template></turbo-stream>
      <turbo-stream action="replace" targets="#message_1"><template>Something else</template></turbo-stream>
      <turbo-stream action="replace" targets="#message_4"><template>Something fourth</template></turbo-stream>
      <turbo-stream action="replace" targets="#message_5"><template>#{render(message_5)}</template></turbo-stream>
      <turbo-stream action="append" targets="#messages"><template>#{render(message_1)}</template></turbo-stream>
      <turbo-stream action="append" targets="#messages"><template>#{render(message_5)}</template></turbo-stream>
      <turbo-stream action="prepend" targets="#messages"><template>#{render(message_1)}</template></turbo-stream>
      <turbo-stream action="prepend" targets="#messages"><template>#{render(message_5)}</template></turbo-stream>
    HTML
  end

  test "includes html format when rendering turbo_stream actions" do
    post posts_path, as: :turbo_stream
    assert_dom_equal <<~HTML.chomp, @response.body
      <turbo-stream action="update" target="form-area"><template>
        Form
      </template></turbo-stream>
    HTML
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

  test "render a renderable object" do
    post notifications_path, as: :turbo_stream

    assert_dom_equal <<~HTML.strip, @response.body
      <turbo-stream action="append" target="notifications"><template><div class='notification'>
        <p>Example notification</p>
      </div></template></turbo-stream>
    HTML
  end
end
