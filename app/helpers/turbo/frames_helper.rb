module Turbo::FramesHelper
  # Returns a frame tag that can either be used simply to encapsulate frame content or as a lazy-loading container that starts empty but
  # fetches the URL supplied in the +src+ attribute. If a +src+ is supplied, the link target for the frame will default to +top+, meaning
  # that links within the frame will replace the entire page, not just the frame.
  #
  # === Examples
  #
  #   # => turbo-frame id="tray" links-target="top" src="http://example.com/trays/1"></turbolinks-frame>
  #   <%= turbo_frame_tag "tray", src: tray_path(tray) %>
  #
  #   # => turbo-frame id="tray" src="http://example.com/trays/1"></turbolinks-frame>
  #   <%= turbo_frame_tag "tray", src: tray_path(tray), links_target: false %>
  #
  #   # => turbo-frame id="tray" links-target="other_tray"></turbolinks-frame>
  #   <%= turbo_frame_tag "tray", links_target: "other_tray" %>
  #
  #   # => turbo-frame id="tray"><div>My tray frame!</div></turbolinks-frame>
  #   <%= turbo_frame_tag "tray" do %>
  #     <div>My tray frame!</div>
  #   <% end %>
  def turbo_frame_tag(id, src: nil, links_target: nil, **attributes, &block)
    links_target ||= links_target != false && src.present? ? "top" : nil

    tag.turbo_frame(**attributes.merge(id: id, src: src, "links-target": links_target).compact, &block)
  end
end
