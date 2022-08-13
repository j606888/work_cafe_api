class AddColumnsToStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :permanently_closed, :boolean, default: false, null: false
    add_column :stores, :hidden, :boolean, default: false, null: false
  end
end
