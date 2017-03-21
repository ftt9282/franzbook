class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  has_many :comments
  validates :content, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true
end
