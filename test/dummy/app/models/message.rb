class Message < ApplicationRecord
  delegate :to_s, to: :content, allow_nil: true
end
