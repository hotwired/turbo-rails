module Turbo::FramesHelper
  # Returns a frame tag that can either be used simply to encapsulate frame content or as a lazy-loading container that starts empty but
  # fetches the URL supplied in the +src+ attribute.
  #
  # === Examples
  #
  #   <%= turbo_frame_tag "tray", src: tray_path(tray) %>
  #   # => <turbo-frame id="tray" src="http://example.com/trays/1"></turbo-frame>
  #
  #   <%= turbo_frame_tag tray, src: tray_path(tray) %>
  #   # => <turbo-frame id="tray_1" src="http://example.com/trays/1"></turbo-frame>
  #
  #   <%= turbo_frame_tag "tray", src: tray_path(tray), target: "_top" %>
  #   # => <turbo-frame id="tray" target="_top" src="http://example.com/trays/1"></turbo-frame>
  #
  #   <%= turbo_frame_tag "tray", target: "other_tray" %>
  #   # => <turbo-frame id="tray" target="other_tray"></turbo-frame>
  #
  #   <%= turbo_frame_tag "tray", src: tray_path(tray), loading: "lazy" %>
  #   # => <turbo-frame id="tray" src="http://example.com/trays/1" loading="lazy"></turbo-frame>
  #
  #   <%= turbo_frame_tag "tray" do %>
  #     <div>My tray frame!</div>
  #   <% end %>
  #   # => <turbo-frame id="tray"><div>My tray frame!</div></turbo-frame>
  def turbo_frame_tag(id, src: nil, target: nil, **attributes, &block)
    id = id.respond_to?(:to_key) ? dom_id(id) : id
    src = url_for(src) if src.present?

    tag.turbo_frame(**attributes.merge(id: id, src: src, target: target).compact, &block)
  end
end
