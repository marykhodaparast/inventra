
class DiscussionPost < ApplicationRecord
  belongs_to :inventory
  belongs_to :user

  has_many :discussion_post_likes, dependent: :destroy
  has_many :liked_by_users, through: :discussion_post_likes, source: :user

  validates :content, presence: true
end
