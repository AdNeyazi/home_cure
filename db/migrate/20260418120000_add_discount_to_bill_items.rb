# frozen_string_literal: true

class AddDiscountToBillItems < ActiveRecord::Migration[8.1]
  def change
    change_table :bill_items, bulk: true do |t|
      t.string :discount_type, null: false, default: "none"
      t.decimal :discount_value, precision: 10, scale: 2, null: false, default: "0.0"
      t.decimal :discount_amount, precision: 12, scale: 2, null: false, default: "0.0"
    end
  end
end
