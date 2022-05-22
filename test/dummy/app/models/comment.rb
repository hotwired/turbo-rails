class Comment < ApplicationRecord
  belongs_to :article

  validates :body, presence: true

  broadcasts_to ->(comment) { [comment.article, :comments] },
    target: ->(comment) { "article_#{comment.article_id}_comments" },
    partial: "comments/different_comment"
end
