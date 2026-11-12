class Inventory < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :custom_fields, dependent: :destroy

  belongs_to :user

  validates :name, presence: true
  validates :visibility, inclusion: { in: %w[private public] }
end
