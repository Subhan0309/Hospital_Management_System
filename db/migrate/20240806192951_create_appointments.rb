class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.references :doctor, null: false, foreign_key: { to_table: :users }
      t.datetime :date_time, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
