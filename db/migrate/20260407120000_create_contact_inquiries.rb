class CreateContactInquiries < ActiveRecord::Migration[8.1]
  def change
    create_table :contact_inquiries do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.string :subject, null: false
      t.text :message, null: false
      t.string :status, null: false, default: "new"

      t.timestamps
    end

    add_index :contact_inquiries, :status
    add_index :contact_inquiries, :created_at
  end
end
