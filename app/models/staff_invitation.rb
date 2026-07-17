class StaffInvitation < ApplicationRecord
  EXPIRY_DAYS = 7
  INVITABLE_ROLES = %w[lab_staff].freeze

  belongs_to :lab
  belongs_to :invited_by, class_name: "User"

  before_validation :normalize_email
  before_validation :assign_token, on: :create
  before_validation :assign_expiry, on: :create

  validates :email, :token, :expires_at, :role, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, uniqueness: true
  validates :role, inclusion: { in: INVITABLE_ROLES }
  validate :email_not_already_registered, on: :create
  validate :no_pending_invite_for_email, on: :create

  scope :pending, -> { where(accepted_at: nil).where("expires_at > ?", Time.current) }
  scope :recent_first, -> { order(created_at: :desc) }

  def pending?
    accepted_at.blank? && !expired?
  end

  def expired?
    expires_at <= Time.current
  end

  def accepted?
    accepted_at.present?
  end

  def accept!(password:, password_confirmation:)
    unless pending?
      errors.add(:base, "Invitation is no longer valid")
      raise ActiveRecord::RecordInvalid, self
    end

    user = User.new(
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      role: role,
      lab: lab
    )

    transaction do
      user.save!
      update!(accepted_at: Time.current)
    end

    user
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def assign_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end

  def assign_expiry
    self.expires_at ||= EXPIRY_DAYS.days.from_now
  end

  def email_not_already_registered
    return if email.blank?
    return unless User.exists?(email: email)

    errors.add(:email, "already has an account")
  end

  def no_pending_invite_for_email
    return if email.blank? || lab.blank?
    return unless lab.staff_invitations.pending.where(email: email).exists?

    errors.add(:email, "already has a pending invitation")
  end
end
