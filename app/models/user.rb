
class User < ApplicationRecord
  has_many :inventories, dependent: :destroy
  has_many :inventory_accesses, dependent: :destroy
  has_many :writable_inventories, through: :inventory_accesses, source: :inventory
  has_many :discussion_posts, dependent: :destroy

  has_many :discussion_post_likes, dependent: :destroy
  has_many :liked_discussion_posts, through: :discussion_post_likes, source: :discussion_post

  has_secure_password

  before_validation :normalize_email

  validates :theme, inclusion: { in: %w[light dark] }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, inclusion: { in: %w[user admin] }

  def admin?
    role == "admin"
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
