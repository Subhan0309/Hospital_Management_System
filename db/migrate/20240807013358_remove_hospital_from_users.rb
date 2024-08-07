class RemoveHospitalFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :hospital_id, :integer
  end
end
