require "turbo_test"

class Turbo::FramesHelperTest < ActionView::TestCase
  test "frame with src" do
    assert_dom_equal %(<turbo-frame src="/trays/1" id="tray"></turbo-frame>), turbo_frame_tag("tray", src: "/trays/1")
  end

  test "frame with src and target" do
    assert_dom_equal %(<turbo-frame src="/trays/1" id="tray" target="_top"></turbo-frame>), turbo_frame_tag("tray", src: "/trays/1", target: "_top")
  end

  test "block style" do
    assert_dom_equal(%(<turbo-frame id="tray"><p>tray!</p></turbo-frame>), turbo_frame_tag("tray") { tag.p("tray!") })
  end
end
