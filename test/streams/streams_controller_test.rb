require "turbo_test"

class Turbo::StreamsControllerTest < ActionDispatch::IntegrationTest
  test "inline page update" do
    get message_path(id: 1), as: :turbo_stream
    assert_turbo_stream command: :remove, container: "message_1"
  end

  test "create with respond to" do
    post messages_path
    assert_redirected_to message_path(id: 1)

    post messages_path, as: :turbo_stream
    assert_response :ok
    assert_turbo_stream command: :append, container: "messages" do |selected|
      assert_equal "message_1", selected.children.to_html
    end
  end
end
