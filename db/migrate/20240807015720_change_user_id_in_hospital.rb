class ChangeUserIdInHospital < ActiveRecord::Migration[6.1]
  def change
    change_column_null :Hospitals, :user_id, true
  end
end
