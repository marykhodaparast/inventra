class CustomField < ApplicationRecord
  FIELD_TYPES = %w[text textarea number link boolean].freeze

  belongs_to :inventory

  before_destroy :remove_values_from_items

  validates :name, presence: true,
                   uniqueness: { scope: :inventory_id }

  validates :field_type, presence: true,
                         inclusion: { in: FIELD_TYPES }

  validates :position, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  private

  def remove_values_from_items
    inventory.items.find_each do |item|
      values = item.custom_field_values || {}
      key = id.to_s

      next unless values.key?(key)

      item.update_columns(
        custom_field_values: values.except(key),
        updated_at: Time.current
      )
    end
  end
end
