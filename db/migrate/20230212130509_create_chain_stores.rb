class CreateChainStores < ActiveRecord::Migration[7.0]
  def change
    create_table :chain_stores do |t|
      t.string :name, null: false
      t.boolean :is_blacklist, default: false, null: false

      t.timestamps
    end
  end
end
