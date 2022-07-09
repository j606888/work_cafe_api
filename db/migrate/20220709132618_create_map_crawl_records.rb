class CreateMapCrawlRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :map_crawl_records do |t|
      t.references :user, null: false, foreign_key: true
      t.float :lat
      t.float :lng
      t.integer :radius
      t.integer :total_found, default: 0
      t.integer :new_store_count, default: 0
      t.integer :repeat_store_count, default: 0
      t.integer :blacklist_store_count, default: 0

      t.timestamps
    end
  end
end
