# frozen_string_literal: true

require "test_helper"

class BillItemTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.create!(full_name: "Discount Patient")
    @bill = Bill.create!(patient: @patient, bill_date: Date.current, status: "pending")
    @test = Test.create!(code: "DISC1", name: "Discount Test", price: 100)
  end

  test "no discount: line total equals subtotal" do
    item = build_item(discount_type: "none", discount_value: 0)
    assert item.valid?
    assert_equal 100, item.subtotal
    assert_equal 0, item.discount_amount
    assert_equal 100, item.line_total
  end

  test "percent discount applies to line subtotal only" do
    item = build_item(quantity: 2, discount_type: "percent", discount_value: 10)
    assert item.valid?
    assert_equal 200, item.subtotal
    assert_equal 20, item.discount_amount
    assert_equal 180, item.line_total
  end

  test "percent discount is capped at 100 percent" do
    item = build_item(discount_type: "percent", discount_value: 100)
    assert item.valid?
    assert_equal 100, item.discount_amount
    assert_equal 0, item.line_total
  end

  test "percent over 100 is invalid" do
    item = build_item(discount_type: "percent", discount_value: 101)
    assert_not item.valid?
    assert_includes item.errors[:discount_value], "must be 100 or less for percent discounts"
  end

  test "fixed amount discount cannot exceed line subtotal" do
    item = build_item(discount_type: "amount", discount_value: 150)
    assert item.valid?
    assert_equal 100, item.discount_amount
    assert_equal 0, item.line_total
  end

  test "multiple lines on one bill sum independently" do
    t2 = Test.create!(code: "DISC2", name: "Other", price: 50)
    i1 = @bill.bill_items.create!(test: @test, quantity: 1, unit_price: 100, discount_type: "percent", discount_value: 10)
    i2 = @bill.bill_items.create!(test: t2, quantity: 1, unit_price: 50, discount_type: "amount", discount_value: 20)
    @bill.reload
    assert_equal 90, i1.line_total
    assert_equal 30, i2.line_total
    assert_equal 120, @bill.total_amount
  end

  private

  def build_item(attrs = {})
    @bill.bill_items.build({ test: @test, quantity: 1, unit_price: 100, discount_type: "none", discount_value: 0 }.merge(attrs))
  end
end
