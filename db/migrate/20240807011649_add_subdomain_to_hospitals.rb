class AddSubdomainToHospitals < ActiveRecord::Migration[6.1]
  def change
    add_column :hospitals, :subdomain, :string
  end
end
