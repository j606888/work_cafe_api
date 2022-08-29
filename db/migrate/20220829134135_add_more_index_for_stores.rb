class AddMoreIndexForStores < ActiveRecord::Migration[7.0]
  def change
    add_index :stores, :city
    add_index :stores, :district
    add_index :stores, :rating
    add_index :stores, :hidden
  end
end
