require "turbo_test"

class Turbo::FramesHelperTest < ActionView::TestCase
  test "links target defaults to top when src is supplied" do
    assert_dom_equal %(<turbolinks-frame src="/trays/1" links-target="top" id="tray"></turbolinks-frame>), turbo_frame_tag("tray", src: "/trays/1")
  end

  test "convert case on links target" do
    assert_dom_equal %(<turbolinks-frame src="/trays/1" links-target="other_tray" id="tray"></turbolinks-frame>),
      turbo_frame_tag("tray", src: "/trays/1", links_target: "other_tray")
  end

  test "opt out of default links target with src" do
    assert_dom_equal %(<turbolinks-frame src="/trays/1" id="tray"></turbolinks-frame>),
      turbo_frame_tag("tray", src: "/trays/1", links_target: false)
  end

  test "block style" do
    assert_dom_equal(%(<turbolinks-frame id="tray"><p>tray!</p></turbolinks-frame>), turbo_frame_tag("tray") { tag.p("tray!") })
  end
end
