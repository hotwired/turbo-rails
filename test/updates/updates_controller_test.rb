require "turbo_test"

class Turbo::UpdatesControllerTest < ActionDispatch::IntegrationTest
  test "inline page update" do
    get message_path(id: 1), as: :turbo_update
    assert_turbo_update command: :remove, container: "message_1"
  end

  test "create with respond to" do
    post messages_path
    assert_redirected_to message_path(id: 1)

    post messages_path, as: :turbo_update
    assert_response :ok
    assert_turbo_update command: :append, container: "messages" do |selected|
      assert_equal "message_1", selected.children.to_html
    end
  end
end
