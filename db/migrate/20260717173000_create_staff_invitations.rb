class CreateStaffInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :staff_invitations do |t|
      t.references :lab, null: false, foreign_key: true
      t.references :invited_by, null: false, foreign_key: { to_table: :users }
      t.string :email, null: false
      t.string :name
      t.string :role, null: false, default: "lab_staff"
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :accepted_at
      t.timestamps
    end

    add_index :staff_invitations, :token, unique: true
    add_index :staff_invitations, %i[lab_id email], unique: true, where: "accepted_at IS NULL", name: "index_staff_invitations_on_lab_pending_email"
  end
end
