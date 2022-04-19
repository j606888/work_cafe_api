class CreateMapCrawlers < ActiveRecord::Migration[7.0]
  def change
    create_table :map_crawlers do |t|
      t.string :name, null: false
      t.string :aasm_state
      t.string :place_id, null: false
      t.float :lat, null: false
      t.float :lng, null:false
      t.jsonb :source_data, default: {}

      t.timestamps
    end
  end
end
