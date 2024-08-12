class AddDoctorIdToMedicalRecords < ActiveRecord::Migration[6.1]
  def change
    add_reference :medical_records, :doctor, null: false, foreign_key: { to_table: :users }
  end
end
