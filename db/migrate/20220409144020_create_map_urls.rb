class CreateMapUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :map_urls do |t|
      t.references :user, null: false, foreign_key: true
      t.string :url, null: false
      t.string :keyword
      t.string :place_id
      t.string :decision
      t.jsonb :source_data, default: {}

      t.timestamps
    end
  end
end
