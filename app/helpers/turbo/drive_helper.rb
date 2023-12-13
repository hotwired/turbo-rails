module Turbo::DriveHelper
  # Note: These helpers require a +turbo_meta_tags+ provision in the layout.
  #
  # ==== Example
  #
  #   # app/views/application.html.erb
  #   <html><head><%= turbo_meta_tags %></head><body><%= yield %></html>
  #
  #   # app/views/trays/index.html.erb
  #   <% turbo_exempts_page_from_cache %>
  #   <p>Page that shouldn't be cached by Turbo</p>

  # Pages that are more likely than not to be a cache miss can skip turbo cache to avoid visual jitter.
  # Cannot be used along with +turbo_exempts_page_from_preview+.
  def turbo_exempts_page_from_cache
    provide :head, turbo_exempts_page_from_cache_tag
  end

  def turbo_exempts_page_from_cache_tag
    tag.meta(name: "turbo-cache-control", content: "no-cache")
  end

  # Specify that a cached version of the page should not be shown as a preview during an application visit.
  # Cannot be used along with +turbo_exempts_page_from_cache+.
  def turbo_exempts_page_from_preview
    provide :head, turbo_exempts_page_from_preview_tag
  end

  def turbo_exempts_page_from_preview_tag
    tag.meta(name: "turbo-cache-control", content: "no-preview")
  end

  # Force the page, when loaded by Turbo, to be cause a full page reload.
  def turbo_page_requires_reload
    provide :head, turbo_page_requires_reload_tag
  end

  def turbo_page_requires_reload_tag
    tag.meta(name: "turbo-visit-control", content: "reload")
  end

  def turbo_refreshes_with(method: :replace, scroll: :reset)
    provide :head, turbo_refresh_method_tag(method)
    provide :head, turbo_refresh_scroll_tag(scroll)
  end

  def turbo_refresh_method_tag(method = :replace)
    raise ArgumentError, "Invalid refresh option '#{method}'" unless method.in?(%i[ replace morph ])
    tag.meta(name: "turbo-refresh-method", content: method)
  end

  def turbo_refresh_scroll_tag(scroll = :reset)
    raise ArgumentError, "Invalid scroll option '#{scroll}'" unless scroll.in?(%i[ reset preserve ])
    tag.meta(name: "turbo-refresh-scroll", content: scroll)
  end

  def turbo_meta_tags
    content_for :head
  end
end

