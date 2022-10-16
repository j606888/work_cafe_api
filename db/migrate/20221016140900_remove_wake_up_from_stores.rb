class RemoveWakeUpFromStores < ActiveRecord::Migration[7.0]
  def change
    remove_column :stores, :wake_up
  end
end
