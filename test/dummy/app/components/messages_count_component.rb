class MessagesCountComponent < ViewComponent::Base
  def initialize(count:)
    @count = count
  end

  def call
    "#{@count} messages sent from component"
  end
end
