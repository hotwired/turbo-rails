class Message < ApplicationRecord
  def to_s
    content
  end
end
