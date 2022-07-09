class CreateStoreSources < ActiveRecord::Migration[7.0]
  def change
    create_table :store_sources do |t|
      t.references :store, null: false, foreign_key: true
      t.jsonb :source_data, null: false, default: {}

      t.timestamps
    end
  end
end
