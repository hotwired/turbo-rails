module Turbo::FramesHelper
  # Returns a frame tag that can either be used simply to encapsulate frame content or as a lazy-loading container that starts empty but
  # fetches the URL supplied in the +src+ attribute.
  #
  # === Examples
  #
  #   # => turbo-frame id="tray" src="http://example.com/trays/1"></turbo-frame>
  #   <%= turbo_frame_tag "tray", src: tray_path(tray) %>
  #
  #   # => turbo-frame id="tray" links-target="top" src="http://example.com/trays/1"></turbo-frame>
  #   <%= turbo_frame_tag "tray", src: tray_path(tray), links_target: "top" %>
  #
  #   # => turbo-frame id="tray" links-target="other_tray"></turbo-frame>
  #   <%= turbo_frame_tag "tray", links_target: "other_tray" %>
  #
  #   # => turbo-frame id="tray"><div>My tray frame!</div></turbo-frame>
  #   <%= turbo_frame_tag "tray" do %>
  #     <div>My tray frame!</div>
  #   <% end %>
  def turbo_frame_tag(id, src: nil, target: nil, **attributes, &block)
    tag.turbo_frame(**attributes.merge(id: id, src: src, target: target).compact, &block)
  end
end
