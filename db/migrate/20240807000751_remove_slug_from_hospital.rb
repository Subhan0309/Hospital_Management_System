class RemoveSlugFromHospital < ActiveRecord::Migration[6.1]
  def change
    remove_column :hospitals, :slug, :string
  end
end
