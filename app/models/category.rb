class Category < ApplicationRecord
  has_many :items, dependent: :nullify
  belongs_to :inventory

  validates :name, presence: true,
                    uniqueness: { scope: :inventory_id }
end
