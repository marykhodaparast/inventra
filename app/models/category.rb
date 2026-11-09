class Category < ApplicationRecord
  belongs_to :inventory

  validates :name, presence: true,
                    uniqueness: { scope: :inventory_id }
end
