module Turbo::DriveHelper
  # Pages that are more likely than not to be a cache miss can skip turbo cache to avoid visual jitter.
  # Note: This requires a +yield :head+ provision in the application layout.
  #
  # ==== Example
  #
  #   # app/views/application.html.erb
  #   <html><head><%= yield :head %></head><body><%= yield %></html>
  #
  #   # app/views/trays/index.html.erb
  #   <% turbo_exempts_page_from_cache %>
  #   <p>Page that shouldn't be cached by Turbo</p>
  def turbo_exempts_page_from_cache
    provide :head, %(<meta name="turbo-cache-control" content="no-cache">).html_safe
  end
end
