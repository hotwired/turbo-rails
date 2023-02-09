require "test_helper"
require "action_cable"

class Turbo::BroadcastableTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  setup { @message = Message.new(id: 1, content: "Hello!") }

  test "broadcasting remove to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("remove", target: "message_1") do
      @message.broadcast_remove_to "stream"
    end
  end

  test "broadcasting remove now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("remove", target: "message_1") do
      @message.broadcast_remove
    end
  end

  test "broadcasting replace to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", template: render(@message)) do
      @message.broadcast_replace_to "stream"
    end
  end

  test "broadcasting replace now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("replace", target: "message_1", template: render(@message)) do
      @message.broadcast_replace
    end
  end

  test "broadcasting update to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("update", target: "message_1", template: render(@message)) do
      @message.broadcast_update_to "stream"
    end
  end

  test "broadcasting update to stream now with template option" do
    assert_broadcast_on "stream", turbo_stream_action_tag("update", target: "message_1", template: render("messages/index", layout: false)) do
      @message.broadcast_update_to "stream", template: "messages/index"
    end
  end

  test "broadcasting update now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", target: "message_1", template: render(@message)) do
      @message.broadcast_update
    end
  end

  test "broadcasting before to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("before", target: "message_1", template: render(@message)) do
      @message.broadcast_before_to "stream", target: "message_1"
    end
  end

  test "broadcasting after to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("after", target: "message_1", template: render(@message)) do
      @message.broadcast_after_to "stream", target: "message_1"
    end
  end

  test "broadcasting append to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("append", target: "messages", template: render(@message)) do
      @message.broadcast_append_to "stream"
    end
  end

  test "broadcasting append to stream with custom target now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("append", target: "board_messages", template: render(@message)) do
      @message.broadcast_append_to "stream", target: "board_messages"
    end
  end

  test "broadcasting append now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("append", target: "messages", template: render(@message)) do
      @message.broadcast_append
    end
  end

  test "broadcasting prepend to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: render(@message)) do
      @message.broadcast_prepend_to "stream"
    end
  end

  test "broadcasting prepend to stream with custom target now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "board_messages", template: render(@message)) do
      @message.broadcast_prepend_to "stream", target: "board_messages"
    end
  end

  test "broadcasting prepend now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", target: "messages", template: render(@message)) do
      @message.broadcast_prepend
    end
  end

  test "broadcasting action to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: render(@message)) do
      @message.broadcast_action_to "stream", action: "prepend"
    end
  end

  test "broadcasting action now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", target: "messages", template: render(@message)) do
      @message.broadcast_action "prepend"
    end
  end

  test "render correct local name in partial for namespaced models" do
    @profile = Users::Profile.new(id: 1, name: "Ryan")
    assert_broadcast_on @profile.to_param, turbo_stream_action_tag("replace", target: "users_profile_1", template: "<p>Ryan</p>\n") do
      @profile.broadcast_replace
    end
  end

  test "local variables don't get overwritten if they collide with the template name" do
    @profile = Users::Profile.new(id: 1, name: "Ryan")
    assert_broadcast_on @profile.to_param, turbo_stream_action_tag("replace", target: "users_profile_1", template: render(@message)) do
      @profile.broadcast_replace partial: 'messages/message', locals: { message: @message }
    end
  end

  test "broadcast render now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("replace", target: "message_1", template: "Goodbye!") do
      @message.broadcast_render
    end
  end

  test "broadcast render to stream now" do
    @profile = Users::Profile.new(id: 1, name: "Ryan")
    assert_broadcast_on @profile.to_param, turbo_stream_action_tag("replace", target: "message_1", template: "Goodbye!") do
      @message.broadcast_render_to @profile
    end
  end
end

class Turbo::BroadcastableArticleTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  test "creating an article broadcasts to the overriden target with a string" do
    assert_broadcast_on "overriden-stream", turbo_stream_action_tag("append", target: "overriden-target", template: "<p>Body</p>\n") do
      perform_enqueued_jobs do
        Article.create!(body: "Body")
      end
    end
  end

  test "updating an article broadcasts" do
    article = Article.create!(body: "Hey")

    assert_broadcast_on "ho", turbo_stream_action_tag("replace", target: "article_#{article.id}", template: "<p>Ho</p>\n") do
      perform_enqueued_jobs do
        article.update!(body: "Ho")
      end
    end
  end

  test "destroying an article broadcasts" do
    article = Article.create!(body: "Hey")

    assert_broadcast_on "hey", turbo_stream_action_tag("remove", target: "article_#{article.id}") do
      article.destroy!
    end
  end
end

class Turbo::BroadcastableCommentTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  setup { @article = Article.create!(body: "Body") }

  test "creating a comment broadcasts to the overriden target with a lambda" do
    stream = "#{@article.to_gid_param}:comments"
    target = "article_#{@article.id}_comments"

    assert_broadcast_on stream, turbo_stream_action_tag("append", target: target, template: %(<p class="different">comment</p>\n)) do
      perform_enqueued_jobs do
        @article.comments.create!(body: "comment")
      end
    end
  end

  test "updating a comment broadcasts" do
    comment = @article.comments.create!(body: "random")
    stream  = "#{@article.to_gid_param}:comments"
    target  = "comment_#{comment.id}"

    assert_broadcast_on stream, turbo_stream_action_tag("replace", target: target, template: %(<p class="different">precise</p>\n)) do
      perform_enqueued_jobs do
        comment.update!(body: "precise")
      end
    end
  end

  test "destroying a comment broadcasts" do
    comment = @article.comments.create!(body: "comment")
    stream  = "#{@article.to_gid_param}:comments"
    target  = "comment_#{comment.id}"

    assert_broadcast_on stream, turbo_stream_action_tag("remove", target: target) do
      comment.destroy!
    end
  end
end
