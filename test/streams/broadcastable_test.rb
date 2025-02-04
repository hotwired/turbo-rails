require "test_helper"
require "action_cable"
require "minitest/mock"

class Turbo::BroadcastableTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  class MessageThatRendersError < Message
    def to_partial_path
      "messages/raises_error"
    end
  end

  setup { @message = Message.new(id: 1, content: "Hello!") }

  test "broadcasting ignores blank streamables" do
    ActionCable.server.stub :broadcast, proc { flunk "expected no broadcasts" } do
      assert_no_broadcasts @message.to_gid_param do
        @message.broadcast_remove_to nil
        @message.broadcast_remove_to [nil]
        @message.broadcast_remove_to ""
        @message.broadcast_remove_to [""]
      end
    end
  end

  test "broadcasting later ignores blank streamables" do
    assert_no_enqueued_jobs do
      @message.broadcast_append_later_to nil
      @message.broadcast_append_later_to [nil]
      @message.broadcast_append_later_to ""
      @message.broadcast_append_later_to [""]
    end
  end

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

  test "broadcasting remove does not render contents" do
    message = MessageThatRendersError.new(id: 1)

    assert_broadcast_on message.to_gid_param, turbo_stream_action_tag("remove", target: dom_id(message)) do
      message.broadcast_remove
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

  test "broadcasting refresh to stream now" do
    assert_broadcast_on "stream", turbo_stream_refresh_tag do
      @message.broadcast_refresh_to "stream"
    end
  end

  test "broadcasting refresh now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_refresh_tag do
      @message.broadcast_refresh
    end
  end

  test "broadcasting refresh does not render contents" do
    message = MessageThatRendersError.new(id: 1)

    assert_broadcast_on message.to_gid_param, turbo_stream_action_tag("refresh") do
      message.broadcast_refresh
    end
  end

  test "broadcasting refresh later is debounced" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_refresh_tag do
      assert_broadcasts(@message.to_gid_param, 1) do
        perform_enqueued_jobs do
          assert_no_changes -> { Thread.current.keys.size } do
            # Not leaking thread variables once the debounced code executes
            3.times { @message.broadcast_refresh_later }
            Turbo::StreamsChannel.refresh_debouncer_for(@message).wait
          end
        end
      end
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

  test "broadcasting action with attributes" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", target: "messages", template: render(@message), "data-foo" => "bar") do
      @message.broadcast_action "prepend", target: "messages", attributes: { "data-foo" => "bar" }
    end
  end

  test "broadcasting action with no rendering" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", target: "messages", template: nil) do
      @message.broadcast_action "prepend", target: "messages", render: false
    end
  end

  test "broadcasting action to with attributes" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: render(@message), "data-foo" => "bar") do
      @message.broadcast_action_to "stream", action: "prepend", attributes: { "data-foo" => "bar" }
    end
  end

  test "broadcasting action to with no rendering" do
    assert_broadcast_on "stream", turbo_stream_action_tag("prepend", target: "messages", template: nil) do
      @message.broadcast_action_to "stream", action: "prepend", render: false
    end
  end

  test "broadcasting action later to with attributes" do
    @message.save!

    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", target: "messages", template: render(@message), "data-foo" => "bar") do
      perform_enqueued_jobs do
        @message.broadcast_action_later_to @message, action: "prepend", target: "messages", attributes: { "data-foo" => "bar" }
      end
    end
  end

  test "broadcasting action later to with no rendering" do
    @message.save!

    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", target: "messages", template: nil) do
      perform_enqueued_jobs do
        @message.broadcast_action_later_to @message, action: "prepend", target: "messages", render: false
      end
    end
  end

  test "broadcasting action later with attributes" do
    @message.save!

    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", target: "messages", template: render(@message), "data-foo" => "bar") do
      perform_enqueued_jobs do
        @message.broadcast_action_later action: "prepend", target: "messages", attributes: { "data-foo" => "bar" }
      end
    end
  end

  test "broadcasting action later with no rendering" do
    @message.save!

    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", target: "messages", template: nil) do
      perform_enqueued_jobs do
        @message.broadcast_action_later action: "prepend", target: "messages", render: false
      end
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

  test "broadcast_update to target string" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", target: "unique_id", template: render(@message)) do
      @message.broadcast_update target: "unique_id"
    end
  end

  test "broadcast_update to target object" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", target: "message_1", template: render(@message)) do
      @message.broadcast_update target: @message
    end
  end

  test "broadcast_update to targets" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", targets: ".message_1", template: render(@message)) do
      @message.broadcast_update targets: ".message_1"
    end
  end

  test "broadcast_update_to to target string" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", target: "unique_id", template: render(@message)) do
      @message.broadcast_update_to @message, target: "unique_id"
    end
  end

  test "broadcast_update_to to target object" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", target: "message_1", template: render(@message)) do
      @message.broadcast_update_to @message, target: @message
    end
  end

  test "broadcast_update_to to targets" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", targets: ".message_1", template: render(@message)) do
      @message.broadcast_update_to @message, targets: ".message_1"
    end
  end

  test "broadcast_append to targets" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("append", targets: ".message_1", template: render(@message)) do
      @message.broadcast_append targets: ".message_1"
    end
  end

  test "broadcast_remove targets" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("remove", targets: ".message_1", template: render(@message)) do
      @message.broadcast_remove targets: ".message_1"
    end
  end

  test "broadcast_append targets" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("append", targets: ".message_1", template: render(@message)) do
      @message.broadcast_append targets: ".message_1"
    end
  end

  test "broadcast_prepend targets" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("prepend", targets: ".message_1", template: render(@message)) do
      @message.broadcast_prepend targets: ".message_1"
    end
  end

  test "broadcast_before_to targets" do
    assert_broadcast_on "stream", turbo_stream_action_tag("before", targets: ".message_1", template: render(@message)) do
      @message.broadcast_before_to "stream", targets: ".message_1"
    end
  end

  test "broadcast_after_to targets" do
    assert_broadcast_on "stream", turbo_stream_action_tag("after", targets: ".message_1", template: render(@message)) do
      @message.broadcast_after_to "stream", targets: ".message_1"
    end
  end

  test "broadcast_update_later" do
    @message.save! # Need to save the record, otherwise Active Job will not be able to retrieve it

    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", target: "unique_id", template: render(@message)) do
      perform_enqueued_jobs do
        @message.broadcast_update_later target: "unique_id"
      end
    end
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", targets: ".message_1", template: render(@message)) do
      perform_enqueued_jobs do
        @message.broadcast_update_later targets: ".message_1"
      end
    end
  end

  test "broadcast_update_later_to" do
    @message.save!

    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", target: "unique_id", template: render(@message)) do
      perform_enqueued_jobs do
        @message.broadcast_update_later_to @message, target: "unique_id"
      end
    end
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", targets: ".message_1", template: render(@message)) do
      perform_enqueued_jobs do
        @message.broadcast_update_later_to @message, targets: ".message_1"
      end
    end
  end

  test "broadcasting replace morph to stream now" do
    assert_broadcast_on "stream", turbo_stream_action_tag("replace", target: "message_1", method: :morph, template: render(@message)) do
      @message.broadcast_replace_to "stream", target: "message_1", attributes: { method: :morph }
    end
  end

  test "broadcasting update morph to stream now targeting" do
    assert_broadcast_on "stream", turbo_stream_action_tag("update", target: "message_1", method: :morph, template: render(@message)) do
      @message.broadcast_update_to "stream", target: "message_1", attributes: { method: :morph }
    end
  end

  test "broadcasting replace morph now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("replace", target: "message_1", method: :morph, template: render(@message)) do
      @message.broadcast_replace target: "message_1", attributes: { method: :morph }
    end
  end

  test "broadcasting update morph now" do
    assert_broadcast_on @message.to_gid_param, turbo_stream_action_tag("update", target: "message_1", method: :morph, template: render(@message)) do
      @message.broadcast_update target: "message_1", attributes: { method: :morph }
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

  test "creating a second comment while using locals broadcasts the second comment" do
    stream = "#{@article.to_gid_param}:comments"
    target = "article_#{@article.id}_comments"

    assert_broadcast_on stream, turbo_stream_action_tag("append", target: target, template: %(<p class="different">comment</p>\n)) do
      perform_enqueued_jobs do
        @article.comments.create!(body: "comment")
      end
    end

    assert_broadcast_on stream, turbo_stream_action_tag("append", target: target, template: %(<p class="different">another comment</p>\n)) do
      perform_enqueued_jobs do
        @article.comments.create!(body: "another comment")
      end
    end
  end

  test "updating a comment broadcasts" do
    comment = @article.comments.create!(body: "random")
    stream = "#{@article.to_gid_param}:comments"
    target = "comment_#{comment.id}"

    assert_broadcast_on stream, turbo_stream_action_tag("replace", target: target, template: %(<p class="different">precise</p>\n)) do
      perform_enqueued_jobs do
        comment.update!(body: "precise")
      end
    end
  end

  test "destroying a comment broadcasts" do
    comment = @article.comments.create!(body: "comment")
    stream = "#{@article.to_gid_param}:comments"
    target = "comment_#{comment.id}"

    assert_broadcast_on stream, turbo_stream_action_tag("remove", target: target) do
      comment.destroy!
    end
  end
end

class Turbo::BroadcastableBoardTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  test "creating a board broadcasts refreshes to a channel using models plural name when creating" do
    assert_broadcast_on "boards", turbo_stream_action_tag("refresh") do
      perform_enqueued_jobs do
        Board.create!(name: "Board")
        Turbo::StreamsChannel.refresh_debouncer_for(["boards"]).wait
      end
    end
  end

  test "updating a board broadcasts to the models channel" do
    board = Board.suppressing_turbo_broadcasts do
      Board.create!(name: "Hey")
    end

    assert_broadcast_on board.to_gid_param, turbo_stream_action_tag("refresh") do
      perform_enqueued_jobs do
        board.update!(name: "Ho")
        Turbo::StreamsChannel.refresh_debouncer_for(board).wait
      end
    end
  end

  test "destroying a board broadcasts refreshes to the model channel" do
    board = Board.suppressing_turbo_broadcasts do
        Board.create!(name: "Hey")
    end

    assert_broadcast_on board.to_gid_param, turbo_stream_action_tag("refresh") do
      board.destroy!
    end
  end
end

class Turbo::SuppressingBroadcastsTest < ActionCable::Channel::TestCase
  include ActiveJob::TestHelper, Turbo::Streams::ActionHelper

  setup { @message = Message.new(id: 1, content: "Hello!") }

  test "suppressing broadcasting remove to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_remove_to "stream"
    end
  end

  test "suppressing broadcasting remove now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_remove
    end
  end

  test "suppressing broadcasting replace to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_replace_to "stream"
    end
  end

  test "suppressing broadcasting replace to stream later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_replace_later_to "stream"
    end
  end

  test "suppressing broadcasting replace now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_replace
    end
  end

  test "suppressing broadcasting replace later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_replace_later
    end
  end

  test "suppressing broadcasting update to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_update_to "stream"
    end
  end

  test "suppressing broadcasting update to stream later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_update_later_to "stream"
    end
  end

  test "suppressing broadcasting update now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_update
    end
  end

  test "suppressing broadcasting update later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_update_later
    end
  end

  test "suppressing broadcasting before to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_before_to "stream", target: "message_1"
    end
  end

  test "suppressing broadcasting after to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_after_to "stream", target: "message_1"
    end
  end

  test "suppressing broadcasting append to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_append_to "stream"
    end
  end

  test "suppressing broadcasting append to stream later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_append_later_to "stream"
    end
  end

  test "suppressing broadcasting append now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_append
    end
  end

  test "suppressing broadcasting append later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_append_later
    end
  end

  test "suppressing broadcasting prepend to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_prepend_to "stream"
    end
  end

  test "suppressing broadcasting prepend to stream later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_prepend_later_to "stream"
    end
  end

  test "suppressing broadcasting refresh to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_refresh_to "stream"
    end
  end

  test "suppressing broadcasting refresh to stream later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_refresh_later_to "stream"
    end
  end

  test "suppressing broadcasting prepend now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_prepend
    end
  end

  test "suppressing broadcasting prepend later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_prepend_later
    end
  end

  test "suppressing broadcasting action to stream now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_action_to "stream", action: "prepend"
    end
  end

  test "suppressing broadcasting action to stream later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_action_later_to "stream", action: "prepend"
    end
  end

  test "suppressing broadcasting action now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_action "prepend"
    end
  end

  test "suppressing broadcasting action later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_action_later action: "prepend"
    end
  end

  test "suppressing broadcast render now" do
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_render
    end
  end

  test "suppressing broadcast render later" do
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_render_later
    end
  end

  test "suppressing broadcast render to stream now" do
    @profile = Users::Profile.new(id: 1, name: "Ryan")
    assert_no_broadcasts_when_suppressing do
      @message.broadcast_render_to @profile
    end
  end

  test "suppressing broadcast render to stream later" do
    @profile = Users::Profile.new(id: 1, name: "Ryan")
    assert_no_broadcasts_later_when_supressing do
      @message.broadcast_render_to @profile
    end
  end

  private
    def assert_no_broadcasts_when_suppressing
      assert_no_broadcasts @message.to_gid_param do
        Message.suppressing_turbo_broadcasts do
          yield
        end
      end
    end

    def assert_no_broadcasts_later_when_supressing
      assert_no_broadcasts_when_suppressing do
        assert_no_enqueued_jobs do
          yield
        end
      end
    end
end
