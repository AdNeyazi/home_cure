class Doctor < ApplicationRecord
  include TenantScoped

  has_many :patients, dependent: :nullify
  has_many :reports, dependent: :nullify

  validates :full_name, :specialization, presence: true

  scope :recent_first, -> { order(created_at: :desc) }
  scope :alphabetical, -> { order(:full_name) }
  scope :search, ->(query) { search_by_fields(query, :full_name, :specialization, :email) }
end
