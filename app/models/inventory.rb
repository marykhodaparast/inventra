class Inventory < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :custom_fields, dependent: :destroy

  belongs_to :user

  before_validation :generate_custom_id, on: :create

  validates :name, presence: true
  validates :visibility, inclusion: { in: %w[private public] }
  validates :custom_id, presence: true, uniqueness: true

  private

  def generate_custom_id
    return if custom_id.present?

    self.id ||= self.class.connection.select_value(
      "SELECT nextval(pg_get_serial_sequence('inventories', 'id'))"
    ).to_i

    self.custom_id = "INV-#{id.to_s.rjust(6, '0')}"
  end
end
