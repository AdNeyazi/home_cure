class CreateLabsAndAddTenancy < ActiveRecord::Migration[8.1]
  def up
    create_table :labs do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :status, null: false, default: "active"
      t.string :contact_email
      t.string :phone_number
      t.text :address
      t.timestamps
    end
    add_index :labs, :slug, unique: true
    add_index :labs, :status

    tenant_tables = %i[users patients doctors tests test_packages bills reports]
    tenant_tables.each do |table|
      add_reference table, :lab, foreign_key: true, null: true
    end

    say_with_time "Backfill existing data into default Home Cure lab" do
      lab_id = insert_default_lab
      tenant_tables.each do |table|
        execute "UPDATE #{table} SET lab_id = #{lab_id} WHERE lab_id IS NULL"
      end
      execute "UPDATE users SET role = 'lab_owner' WHERE role = 'admin'"
    end

    change_column_null :patients, :lab_id, false
    change_column_null :doctors, :lab_id, false
    change_column_null :tests, :lab_id, false
    change_column_null :test_packages, :lab_id, false
    change_column_null :bills, :lab_id, false
    change_column_null :reports, :lab_id, false

    change_column_default :users, :role, from: "admin", to: "lab_owner"

    remove_index :tests, :code if index_exists?(:tests, :code)
    add_index :tests, %i[lab_id code], unique: true

    remove_index :test_packages, :code if index_exists?(:test_packages, :code)
    add_index :test_packages, %i[lab_id code], unique: true

    remove_index :bills, :bill_number if index_exists?(:bills, :bill_number)
    add_index :bills, %i[lab_id bill_number], unique: true
  end

  def down
    remove_index :bills, %i[lab_id bill_number] if index_exists?(:bills, %i[lab_id bill_number])
    add_index :bills, :bill_number, unique: true

    remove_index :test_packages, %i[lab_id code] if index_exists?(:test_packages, %i[lab_id code])
    add_index :test_packages, :code, unique: true

    remove_index :tests, %i[lab_id code] if index_exists?(:tests, %i[lab_id code])
    add_index :tests, :code, unique: true

    change_column_default :users, :role, from: "lab_owner", to: "admin"
    execute "UPDATE users SET role = 'admin' WHERE role IN ('lab_owner', 'lab_staff', 'super_admin')"

    %i[reports bills test_packages tests doctors patients users].each do |table|
      remove_reference table, :lab, foreign_key: true
    end

    drop_table :labs
  end

  private

  def insert_default_lab
    now = connection.quote(Time.current)
    select_value(<<~SQL.squish)
      INSERT INTO labs (name, slug, status, contact_email, created_at, updated_at)
      VALUES ('Home Cure Lab', 'home-cure-lab', 'active', 'admin@homecurelab.com', #{now}, #{now})
      RETURNING id
    SQL
  end
end
