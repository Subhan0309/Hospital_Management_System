
class AddHospitalIdToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :hospital_id, :bigint
    add_index :appointments, :hospital_id
  end
end