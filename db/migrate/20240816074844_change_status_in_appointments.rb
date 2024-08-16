class ChangeStatusInAppointments < ActiveRecord::Migration[6.1]
  def up
    # Change column type from integer to string
    change_column :appointments, :status, :string, default: 'scheduled', null: false
    
  
  end

  def down
    # Rollback column type to integer and revert the string values to integers
    change_column :appointments, :status, :integer, default: 0, null: false
    
  
  end
end
