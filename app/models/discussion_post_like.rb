class DiscussionPostLike < ApplicationRecord
  belongs_to :discussion_post
  belongs_to :user

  validates :user_id, uniqueness: { scope: :discussion_post_id }
end
