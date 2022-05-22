class Article < ApplicationRecord
  has_many :comments

  validates :body, presence: true

  broadcasts "overriden-stream", target: "overriden-target"

  def to_gid_param
    to_param
  end

  def to_param
    body.parameterize
  end
end
