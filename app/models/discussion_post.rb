class DiscussionPost < ApplicationRecord
  belongs_to :inventory
  belongs_to :user

  validates :content, presence: true
end
