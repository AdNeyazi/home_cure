class Lab < ApplicationRecord
  STATUSES = %w[active suspended].freeze

  has_many :users, dependent: :restrict_with_error
  has_many :staff_invitations, dependent: :destroy
  has_many :patients, dependent: :restrict_with_error
  has_many :doctors, dependent: :restrict_with_error
  has_many :tests, dependent: :restrict_with_error
  has_many :test_packages, dependent: :restrict_with_error
  has_many :bills, dependent: :restrict_with_error
  has_many :reports, dependent: :restrict_with_error

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :status, inclusion: { in: STATUSES }

  before_validation :generate_slug, on: :create

  scope :active, -> { where(status: "active") }
  scope :recent_first, -> { order(created_at: :desc) }

  def active?
    status == "active"
  end

  def suspended?
    status == "suspended"
  end

  private

  def generate_slug
    return if slug.present?
    return if name.blank?

    base = name.to_s.parameterize.presence || "lab"
    candidate = base
    counter = 2
    while Lab.exists?(slug: candidate)
      candidate = "#{base}-#{counter}"
      counter += 1
    end
    self.slug = candidate
  end
end
