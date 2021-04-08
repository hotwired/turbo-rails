require 'active_record'

class ChatRoom
  include ActiveModel::Model
  include Turbo::Broadcastable
  include ActiveRecord::Transactions
  include ActiveRecord::Persistence

  broadcasts_to ->(chat_room) { :chat_rooms }, target: "chat_rooms", partial: "chat_rooms/different_chat_room"

  attr_accessor :id, :name

  def to_partial_path
    "chat_rooms/chat_room"
  end
end
