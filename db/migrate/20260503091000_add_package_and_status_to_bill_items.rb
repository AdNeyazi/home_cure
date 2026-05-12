class AddPackageAndStatusToBillItems < ActiveRecord::Migration[8.1]
  def change
    add_reference :bill_items, :test_package, foreign_key: true
    add_column :bill_items, :status, :string, null: false, default: "active"
    add_index :bill_items, :status
  end
end
