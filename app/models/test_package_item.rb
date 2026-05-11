class TestPackageItem < ApplicationRecord
  belongs_to :test_package
  belongs_to :test

  validates :test_id, uniqueness: { scope: :test_package_id }
end
