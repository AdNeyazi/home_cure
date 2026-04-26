class AddDoctorToPatients < ActiveRecord::Migration[8.1]
  def change
    add_reference :patients, :doctor, null: true, foreign_key: true
  end
end
