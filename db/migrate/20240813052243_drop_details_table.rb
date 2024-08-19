class DropDetailsTable < ActiveRecord::Migration[6.1]
  def change
    def up
      drop_table :details
    end
  
    def down
      create_table :details do |t|
        t.bigint :user_id, null: false
        t.string :specialization
        t.string :qualification
        t.string :disease
        t.string :status
        t.timestamps
      end
  
      add_index :details, :user_id, name: "index_details_on_user_id"
    end
  end
end
