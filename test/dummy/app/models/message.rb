class Message
  include Turbo::Broadcastable

  attr_reader :record_id, :content

  def self.model_name
    ActiveModel::Name.new(self)
  end

  def initialize(record_id:, content:)
    @record_id, @content = record_id, content
  end

  def to_key
    [ record_id ]
  end

  def to_param
    record_id.to_s
  end

  def to_partial_path
    "messages/message"
  end

  def to_s
    content
  end

  def model_name
    self.class.model_name
  end

  def to_model
    self
  end

  def persisted?
    true
  end
end
