class UpdateAppointmentsColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :appointments, :date_time, :datetime
    add_column :appointments, :startTime, :datetime, null: false
    add_column :appointments, :endTime, :datetime, null: false
  end
end
