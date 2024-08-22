class AddHospitalIdToMedicalRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :medical_records, :hospital_id, :bigint
    add_index :medical_records, :hospital_id
  end
end