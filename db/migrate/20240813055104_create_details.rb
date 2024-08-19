class CreateDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :details do |t|
      t.references :associated_with, polymorphic: true, null: false
      t.string :specialization
      t.string :qualification
      t.string :disease
      t.string :status
      t.timestamps
    end
  end
end
