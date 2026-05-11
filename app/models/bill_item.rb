# frozen_string_literal: true

class BillItem < ApplicationRecord
  DISCOUNT_TYPES = %w[none percent amount].freeze
  STATUSES = %w[active cancelled].freeze

  belongs_to :bill
  belongs_to :test
  belongs_to :test_package, optional: true

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :discount_type, inclusion: { in: DISCOUNT_TYPES }
  validates :discount_value, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validate :percent_discount_within_range

  before_validation :set_unit_price_from_test, unless: :marked_for_destruction?
  before_validation :set_default_status, unless: :marked_for_destruction?
  before_validation :normalize_discount_fields, unless: :marked_for_destruction?
  before_validation :apply_line_pricing, unless: :marked_for_destruction?

  # Subtotal before any line discount (used for multi-line bills, edits, and display).
  def subtotal
    unit_price.to_d * quantity.to_i
  end

  def cancelled?
    status == "cancelled"
  end

  def add_on?
    test_package_id.blank?
  end

  def investigation_name
    return test.name if test_package.blank?

    "#{test_package.name} - #{test.name}"
  end

  private

  def set_default_status
    self.status = "active" if status.blank?
  end

  def set_unit_price_from_test
    self.unit_price = test.price if test.present? && unit_price.blank?
  end

  def normalize_discount_fields
    self.discount_type = "none" if discount_type.blank?
    self.discount_value = discount_value.to_s.strip.empty? ? 0.to_d : discount_value.to_d
    self.discount_value = 0 if discount_type == "none"
  end

  def apply_line_pricing
    if cancelled?
      self.discount_amount = 0
      self.line_total = 0
      return
    end

    base = subtotal
    self.discount_amount = computed_discount_amount(base)
    self.line_total = (base - discount_amount).round(2)
  end

  def computed_discount_amount(base)
    case discount_type
    when "none"
      0.to_d
    when "percent"
      pct = discount_value.to_d
      return 0.to_d if pct <= 0

      [ (base * pct / 100).round(2), base ].min
    when "amount"
      amt = discount_value.to_d
      return 0.to_d if amt <= 0

      [ amt, base ].min
    else
      0.to_d
    end
  end

  def percent_discount_within_range
    return unless discount_type == "percent"
    return if discount_value.blank?

    if discount_value.to_d > 100
      errors.add(:discount_value, "must be 100 or less for percent discounts")
    end
  end
end
