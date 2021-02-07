class Comment
  include ActiveModel::Model

  attr_accessor :record_id, :content, :message

  private

  def broadcast_target_default
    "message_#{message.record_id}_comments"
  end
end
