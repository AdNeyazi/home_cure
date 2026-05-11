class CreateTestPackages < ActiveRecord::Migration[8.1]
  def change
    create_table :test_packages do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, default: 0, null: false

      t.timestamps
    end

    add_index :test_packages, :code, unique: true
    add_index :test_packages, :name

    create_table :test_package_items do |t|
      t.references :test_package, null: false, foreign_key: true
      t.references :test, null: false, foreign_key: true

      t.timestamps
    end

    add_index :test_package_items, [ :test_package_id, :test_id ], unique: true
  end
end
