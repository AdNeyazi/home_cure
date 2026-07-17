class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[super_admin lab_owner lab_staff].freeze

  belongs_to :lab, optional: true
  has_many :staff_invitations, foreign_key: :invited_by_id, dependent: :restrict_with_error, inverse_of: :invited_by

  validates :role, inclusion: { in: ROLES }
  validate :lab_required_for_lab_members
  validate :super_admin_must_not_have_lab

  scope :lab_owners, -> { where(role: "lab_owner") }
  scope :lab_staff_members, -> { where(role: "lab_staff") }
  scope :recent_first, -> { order(created_at: :desc) }
  def super_admin?
    role == "super_admin"
  end

  def lab_owner?
    role == "lab_owner"
  end

  def lab_staff?
    role == "lab_staff"
  end

  def lab_member?
    lab_owner? || lab_staff?
  end

  # Backward-compatible alias used by existing views/controllers.
  def admin?
    lab_member? || super_admin?
  end

  private

  def lab_required_for_lab_members
    return unless lab_member?
    return if lab.present?

    errors.add(:lab, "must be present for lab members")
  end

  def super_admin_must_not_have_lab
    return unless super_admin?
    return if lab.blank?

    errors.add(:lab, "must be blank for platform super admins")
  end
end
