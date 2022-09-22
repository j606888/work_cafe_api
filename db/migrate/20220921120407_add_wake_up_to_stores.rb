class AddWakeUpToStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :wake_up, :boolean, null: false, default: false
  end
end
