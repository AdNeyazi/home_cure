class Bill < ApplicationRecord
  STATUSES = %w[pending paid cancelled].freeze

  belongs_to :patient
  has_many :bill_items, dependent: :destroy

  accepts_nested_attributes_for :bill_items, allow_destroy: true

  validates :bill_date, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :amount_paid, numericality: { greater_than_or_equal_to: 0 }
  validates :amount_due, numericality: { greater_than_or_equal_to: 0 }
  validates :bill_number, uniqueness: true, allow_blank: true
  validate :amount_paid_cannot_exceed_total
  validate :paid_bill_must_have_no_due

  scope :recent_first, -> { order(bill_date: :desc) }
  scope :with_patient, -> { includes(:patient) }
  scope :pending, -> { where(status: "pending") }
  scope :paid, -> { where(status: "paid") }

  before_validation :set_default_bill_date
  before_validation :assign_bill_number
  before_validation :sync_payment_fields
  before_save :calculate_total_amount
  before_save :sync_payment_fields

  def gross_amount
    bill_items.reject(&:marked_for_destruction?).sum(&:subtotal)
  end

  def total_discount
    bill_items.reject(&:marked_for_destruction?).sum { |item| item.discount_amount.to_d }
  end

  def amount_paid_in_words
    AmountInWords.new(amount_paid).to_words
  end

  def paid?
    status == "paid"
  end

  def pending?
    status == "pending"
  end

  private

  def set_default_bill_date
    self.bill_date ||= Date.current
  end

  def calculate_total_amount
    self.total_amount = bill_items.reject(&:marked_for_destruction?).sum do |item|
      item.line_total.to_d
    end
  end

  def assign_bill_number
    return if bill_number.present?

    self.bill_number = BillNumberGenerator.new(self.class).generate
  end

  def sync_payment_fields
    self.amount_paid = amount_paid.to_d
    self.amount_paid = total_amount.to_d if paid?
    self.amount_due = (total_amount.to_d - amount_paid.to_d).round(2)
  end

  def amount_paid_cannot_exceed_total
    return if amount_paid.to_d <= total_amount.to_d

    errors.add(:amount_paid, "cannot be greater than net total")
  end

  def paid_bill_must_have_no_due
    return unless paid?
    return if amount_due.to_d.zero?

    errors.add(:status, "paid bills must have zero due amount")
  end
end
