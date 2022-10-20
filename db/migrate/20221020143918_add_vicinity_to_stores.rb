class AddVicinityToStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :vicinity, :string
  end
end
