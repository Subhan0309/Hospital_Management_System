
class AddHospitalIdToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :hospital_id, :bigint
    add_index :comments, :hospital_id
  end
end