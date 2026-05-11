class Test < ApplicationRecord
  has_many :bill_items, dependent: :restrict_with_error
  has_many :reports, dependent: :nullify
  has_many :test_package_items, dependent: :restrict_with_error
  has_many :test_packages, through: :test_package_items

  validates :code, :name, presence: true
  validates :code, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :recent_first, -> { order(created_at: :desc) }
  scope :alphabetical, -> { order(:name) }
  scope :search, ->(query) { search_by_fields(query, :code, :name) }
end
