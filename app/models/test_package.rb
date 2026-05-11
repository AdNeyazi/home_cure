class TestPackage < ApplicationRecord
  has_many :test_package_items, dependent: :destroy
  has_many :tests, through: :test_package_items
  has_many :bill_items, dependent: :nullify

  accepts_nested_attributes_for :test_package_items, allow_destroy: true

  validates :code, :name, presence: true
  validates :code, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_at_least_one_test

  scope :recent_first, -> { order(created_at: :desc) }
  scope :alphabetical, -> { order(:name) }

  def test_names
    tests.order(:name).pluck(:name).join(", ")
  end

  private

  def must_have_at_least_one_test
    active_items = test_package_items.reject(&:marked_for_destruction?)
    errors.add(:tests, "must include at least one test") if active_items.empty?
  end
end
