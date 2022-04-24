class AddImageUrlToStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :image_url, :string
  end
end
