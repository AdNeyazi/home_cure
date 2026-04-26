class ContactInquiry < ApplicationRecord
  STATUSES = %w[new resolved].freeze

  validates :full_name, :email, :subject, :message, presence: true
  validates :status, inclusion: { in: STATUSES }

  scope :recent_first, -> { order(created_at: :desc) }
  scope :open, -> { where(status: "new") }
  scope :resolved, -> { where(status: "resolved") }
end
