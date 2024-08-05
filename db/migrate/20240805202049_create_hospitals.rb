class CreateHospitals < ActiveRecord::Migration[6.1]
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :location
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :license_no
      t.string :slug

      t.timestamps
    end
    add_index :hospitals, :slug, unique: true
  end
end
