class AddPaymentFieldsToBills < ActiveRecord::Migration[8.1]
  def change
    change_table :bills, bulk: true do |t|
      t.string :bill_number
      t.decimal :amount_paid, precision: 12, scale: 2, null: false, default: "0.0"
      t.decimal :amount_due, precision: 12, scale: 2, null: false, default: "0.0"
    end

    add_index :bills, :bill_number, unique: true
  end
end
