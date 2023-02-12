class NotificationComponent
  def render_in(view_context, &block)
    "<div class='notification'>#{view_context.capture(&block)}</div>".html_safe
  end
end
