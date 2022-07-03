class CreateStoreSources < ActiveRecord::Migration[7.0]
  def change
    create_table :store_sources do |t|
      t.integer :user_id
      t.string :place_id, null: false
      t.string :aasm_state, null: false
      t.string :create_type, null: false
      t.jsonb :source_data, null: false, default: {}

      t.timestamps

      t.index :place_id, unique: true
    end
  end
end
