module Turbo::FramesHelper
  # Returns a frame tag that can either be used simply to encapsulate frame content or as a lazy-loading container that starts empty but
  # fetches the URL supplied in the +src+ attribute.
  #
  # ==== Examples
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
  #
  #   <%= turbo_frame_tag [user_id, "tray"], src: tray_path(tray) %>
  #   # => <turbo-frame id="1_tray" src="http://example.com/trays/1"></turbo-frame>
  #
  # The +turbo_frame_tag+ helper will convert the arguments it receives to their
  # +dom_id+ if applicable to easily generate unique ids for Turbo Frames:
  #
  #   <%= turbo_frame_tag(Article.find(1)) %>
  #   # => <turbo-frame id="article_1"></turbo-frame>
  #
  #   <%= turbo_frame_tag(Article) %>
  #   # => <turbo-frame id="new_article"></turbo-frame>
  #
  #   <%= turbo_frame_tag(Article.find(1), "comments") %>
  #   # => <turbo-frame id="comments_article_1"></turbo-frame>
  # Optional: pass `partial:` (and optionally `locals:`) to define the
  # frame's boundary and its file in one place. No app/views/.../_x.html.erb
  # needed: Turbo::PartialExtractor captures the block's own ERB source and
  # makes it renderable under that name via Turbo::CachedPartialResolver.
  #   <%= turbo_frame_tag dom_id(post, :like), partial: "posts/like", locals: { post: post } do %>
  #     ...
  #   <% end %>
  def turbo_frame_tag(*ids, src: nil, target: nil, partial: nil, locals: {}, **attributes, &block)
    id = ids.first.respond_to?(:to_key) || ids.first.is_a?(Class) ? ActionView::RecordIdentifier.dom_id(*ids) : ids.join('_')
    src = url_for(src) if src.present?

    Turbo::PartialExtractor.ensure_generated!(partial, block) if partial && block

    tag.turbo_frame(**attributes.merge(id: id, src: src, target: target).compact, &block)
  end
end
