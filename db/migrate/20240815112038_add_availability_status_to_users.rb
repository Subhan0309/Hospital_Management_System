class AddAvailabilityStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :availability_status, :string, default: 'Available'
  end
end
