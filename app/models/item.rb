class Item < ApplicationRecord
  belongs_to :inventory
  belongs_to :category, optional: true

  validates :name, presence: true
  validate :category_belongs_to_inventory

  private

  def category_belongs_to_inventory
    return if category.nil?
    return if category.inventory_id == inventory_id

    errors.add(:category, "must belong to the same inventory")
  end
end
