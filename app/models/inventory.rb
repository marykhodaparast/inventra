class Inventory < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :visibility, inclusion: { in: %w[private public] }
end
