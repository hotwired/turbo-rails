class Message
  include Turbo::Broadcastable

  def initialize(record_id)
    @record_id = record_id
  end

  def to_key
    [ @record_id ]
  end

  def to_param
    "message:#{@record_id}"
  end

  def model_name
    ActiveModel::Name.new(self.class)
  end
end
