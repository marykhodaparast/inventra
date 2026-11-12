class Item < ApplicationRecord
  belongs_to :inventory
  belongs_to :category, optional: true

  before_validation :normalize_custom_field_values

  validates :name, presence: true
  validate :category_belongs_to_inventory
  validate :custom_field_values_match_fields

  private

  def category_belongs_to_inventory
    return if category.nil?
    return if category.inventory_id == inventory_id

    errors.add(:category, "must belong to the same inventory")
  end

  def normalize_custom_field_values
    return unless custom_field_values.is_a?(Hash)

    normalized_values = {}

    inventory.custom_fields.each do |field|
      key = field.id.to_s
      value = custom_field_values[key]

      normalized_values[key] =
        case field.field_type
        when "number"
          normalize_number(value)
        when "boolean"
          value == "1" || value == true
        else
          value
        end
    end

    self.custom_field_values = normalized_values
  end

  def normalize_number(value)
    return nil if value.blank?

    Float(value)
  rescue ArgumentError, TypeError
    value
  end

  def custom_field_values_match_fields
    return unless custom_field_values.is_a?(Hash)

    inventory.custom_fields.each do |field|
      value = custom_field_values[field.id.to_s]

      if field.field_type == "number" && value.present? && !value.is_a?(Numeric)
        errors.add(:base, "#{field.name} must be a valid number")
      end
    end
  end
end
