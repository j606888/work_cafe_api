class AddColumnsToBlacklists < ActiveRecord::Migration[7.0]
  def change
    add_column :blacklists, :is_delete, :boolean, default: false, null: false
  end
end
