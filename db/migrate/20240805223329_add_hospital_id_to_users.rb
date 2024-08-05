

class AddHospitalIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :hospital_id, :integer, null: true # optional foreign key
  end
end
