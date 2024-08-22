class ChangeHospitalIdToAllowNull < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :hospital_id, :bigint, null: true
  end
end
