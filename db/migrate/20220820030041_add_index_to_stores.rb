class AddIndexToStores < ActiveRecord::Migration[7.0]
  def change
    add_index :stores, :name
  end
end
