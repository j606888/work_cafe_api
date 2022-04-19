class RemoveMapUrlIdFromStores < ActiveRecord::Migration[7.0]
  def change
    remove_column :stores, :map_url_id, :integer
  end
end
