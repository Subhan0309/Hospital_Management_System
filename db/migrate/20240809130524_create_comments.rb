class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :description
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.references :associated_with, polymorphic: true, index: true

      t.timestamps
    end
  end
end
