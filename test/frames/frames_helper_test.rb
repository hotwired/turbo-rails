require "turbo_test"

class Turbo::FramesHelperTest < ActionView::TestCase
  setup { Message.delete_all }

  test "frame with src" do
    assert_dom_equal %(<turbo-frame src="/trays/1" id="tray" aria-live="polite"></turbo-frame>), turbo_frame_tag("tray", src: "/trays/1")
  end

  test "frame with aria-live override" do
    assert_dom_equal %(<turbo-frame src="/trays/1" id="tray" aria-live="off"></turbo-frame>), turbo_frame_tag("tray", src: "/trays/1", aria: { live: "off" })
    assert_dom_equal %(<turbo-frame src="/trays/1" id="tray" aria-live="off"></turbo-frame>), turbo_frame_tag("tray", src: "/trays/1", "aria-live": "off")
    assert_dom_equal %(<turbo-frame src="/trays/1" id="tray" aria-live="off"></turbo-frame>), turbo_frame_tag("tray", src: "/trays/1", "aria": { "live": "off" })
  end

  test "frame with model src" do
    record = Message.create(id: "1", content: "ignored")

    assert_dom_equal %(<turbo-frame src="/messages/1" id="message" aria-live="polite"></turbo-frame>), turbo_frame_tag("message", src: record)
  end

  test "frame with src and target" do
    assert_dom_equal %(<turbo-frame src="/trays/1" id="tray" target="_top" aria-live="polite"></turbo-frame>), turbo_frame_tag("tray", src: "/trays/1", target: "_top")
  end

  test "frame with model argument" do
    record = Message.new(id: "1", content: "ignored")

    assert_dom_equal %(<turbo-frame id="message_1" aria-live="polite"></turbo-frame>), turbo_frame_tag(record)
  end

  test "string frame nested withing a model frame" do
    record = Article.new(id: 1)

    assert_dom_equal %(<turbo-frame id="article_1_comments" aria-live="polite"></turbo-frame>), turbo_frame_tag(record, "comments")
  end

  test "model frame nested withing another model frame" do
    record = Article.new(id: 1)
    nested_record = Comment.new

    assert_dom_equal %(<turbo-frame id="article_1_new_comment" aria-live="polite"></turbo-frame>), turbo_frame_tag(record, nested_record)
  end

  test "block style" do
    assert_dom_equal(%(<turbo-frame id="tray" aria-live="polite"><p>tray!</p></turbo-frame>), turbo_frame_tag("tray") { tag.p("tray!") })
  end
end
