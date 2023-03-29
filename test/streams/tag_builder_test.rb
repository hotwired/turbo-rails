require "tag_builder_test_case"

class Turbo::TagBuilderTest < TagBuilderTestCase
  test "action with name and target as args" do
    stream = %(<turbo-stream action="custom_action" target="custom_target"><template></template></turbo-stream>)

    assert_equal stream, turbo_stream.action("custom_action", "custom_target")
  end

  test "action with name, target and content as args" do
    stream = %(<turbo-stream action="custom_action" target="custom_target"><template>Custom Content</template></turbo-stream>)

    assert_equal stream, turbo_stream.action("custom_action", "custom_target", "Custom Content")
  end

  test "action with name and target as args and content as kwarg" do
    stream = %(<turbo-stream action="custom_action" target="custom_target"><template>Custom Content</template></turbo-stream>)

    assert_equal stream, turbo_stream.action("custom_action", "custom_target", content: "Custom Content")
  end

  test "action with name as arg and target as kwarg" do
    stream = %(<turbo-stream action="custom_action" target="custom_target"><template></template></turbo-stream>)

    assert_equal stream, turbo_stream.action("custom_action", target: "custom_target")
  end

  test "action with name and targets as kwargs" do
    stream = %(<turbo-stream action="custom_action" target="custom_target"><template></template></turbo-stream>)

    assert_equal stream, turbo_stream.action(name: "custom_action", target: "custom_target")
  end

  test "action with name, targets and content as kwargs" do
    stream = %(<turbo-stream action="custom_action" target="custom_target"><template>Custom Content</template></turbo-stream>)

    assert_equal stream, turbo_stream.action(name: "custom_action", target: "custom_target", content: "Custom Content")
  end

  test "action should use args over kwargs if both are provided" do
    stream = %(<turbo-stream action="custom_action" target="custom_target"><template></template></turbo-stream>)

    assert_equal stream, turbo_stream.action("custom_action", "custom_target", name: "not_used_action", target: "not_used_target")
  end

  test "action_all with name and targets as args" do
    stream = %(<turbo-stream action="custom_action" targets="custom_targets"><template></template></turbo-stream>)

    assert_equal stream, turbo_stream.action_all("custom_action", "custom_targets")
  end

  test "action_all with name, targets and content as args" do
    stream = %(<turbo-stream action="custom_action" targets="custom_targets"><template>Custom Content</template></turbo-stream>)

    assert_equal stream, turbo_stream.action_all("custom_action", "custom_targets", "Custom Content")
  end

  test "action_all with name and targets as args and content as kwarg" do
    stream = %(<turbo-stream action="custom_action" targets="custom_targets"><template>Custom Content</template></turbo-stream>)

    assert_equal stream, turbo_stream.action_all("custom_action", "custom_targets", content: "Custom Content")
  end

  test "action_all with name as arg and targets as kwarg" do
    stream = %(<turbo-stream action="custom_action" targets="custom_targets"><template></template></turbo-stream>)

    assert_equal stream, turbo_stream.action_all("custom_action", targets: "custom_targets")
  end

  test "action_all with name and targets as kwargs" do
    stream = %(<turbo-stream action="custom_action" targets="custom_targets"><template></template></turbo-stream>)

    assert_equal stream, turbo_stream.action_all(name: "custom_action", targets: "custom_targets")
  end

  test "action_all with name targets and content as kwargs" do
    stream = %(<turbo-stream action="custom_action" targets="custom_targets"><template>Custom Content</template></turbo-stream>)

    assert_equal stream, turbo_stream.action_all(name: "custom_action", targets: "custom_targets", content: "Custom Content")
  end

  test "action_all should use args over kwargs if both are provided" do
    stream = %(<turbo-stream action="custom_action" targets="custom_targets"><template></template></turbo-stream>)

    assert_equal stream, turbo_stream.action_all("custom_action", "custom_targets", name: "not_used_action", targets: "not_used_target")
  end
end
