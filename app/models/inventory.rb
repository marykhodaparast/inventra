class Inventory < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :custom_fields, dependent: :destroy
  has_many :inventory_accesses, dependent: :destroy
  has_many :users_with_write_access,
         through: :inventory_accesses,
         source: :user
  has_many :inventory_tags, dependent: :destroy
  has_many :tags, through: :inventory_tags

  belongs_to :user

  before_validation :generate_custom_id, on: :create

  validates :name, presence: true
  validates :visibility, inclusion: { in: %w[private public] }
  validates :custom_id, presence: true, uniqueness: true

 def writable_by?(user)
    return false unless user

    return true if user.admin? || user_id == user.id
    return true if visibility == "public"

    users_with_write_access.exists?(id: user.id)
  end

  def self.search(query)
  return none if query.blank?

  where(
    "search_vector @@ websearch_to_tsquery('english', ?)",
    query
  )
  end

  private

  def generate_custom_id
    return if custom_id.present?

    self.id ||= self.class.connection.select_value(
      "SELECT nextval(pg_get_serial_sequence('inventories', 'id'))"
    ).to_i

    self.custom_id = "INV-#{id.to_s.rjust(6, '0')}"
  end
end
