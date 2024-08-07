class CreateMedicalRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :medical_records do |t|
      t.datetime :date, null: false
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.text :details, null: false

      t.timestamps
    end
  end
end
