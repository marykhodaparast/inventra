class CustomField < ApplicationRecord
  FIELD_TYPES = %w[text textarea number link boolean].freeze

  belongs_to :inventory

  validates :name, presence: true,
                   uniqueness: { scope: :inventory_id }

  validates :field_type, presence: true,
                         inclusion: { in: FIELD_TYPES }

  validates :position, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
end
