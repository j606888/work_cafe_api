class CreateChainStoreMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :chain_store_maps do |t|
      t.references :chain_store, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
