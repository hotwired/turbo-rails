class MessageComponent
  def initialize(text)
    @text = text
  end

  def render_in(view_context)
    "<div class='test-message'>#{@text}</div>".html_safe
  end

  def format
    :html
  end
end
