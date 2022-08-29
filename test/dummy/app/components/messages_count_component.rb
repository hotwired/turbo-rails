class MessagesCountComponent
  def initialize(count:)
    @count = count
  end

  def render_in(_view_context)
    "#{@count} messages sent from component"
  end

  def format
    :html
  end
end
