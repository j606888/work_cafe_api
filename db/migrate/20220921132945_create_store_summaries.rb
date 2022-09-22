class CreateStoreSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :store_summaries do |t|
      t.references :store, null: false, foreign_key: true
      t.integer :recommend_yes, default: 0
      t.integer :recommend_normal, default: 0
      t.integer :recommend_no, default: 0
      t.integer :room_volume_quiet, default: 0
      t.integer :room_volume_normal, default: 0
      t.integer :room_volume_loud, default: 0
      t.integer :time_limit_no, default: 0
      t.integer :time_limit_weekend, default: 0
      t.integer :time_limit_yes, default: 0
      t.integer :socket_supply_no, default: 0
      t.integer :socket_supply_rare, default: 0
      t.integer :socket_supply_yes, default: 0

      t.timestamps
    end
  end
end
