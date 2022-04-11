class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.string :place_id, null: false, unique: true
      t.string :address
      t.string :phone
      t.string :url, null: false
      t.string :website
      t.float :rating
      t.integer :user_ratings_total
      t.float :location_lat
      t.float :location_lng
      t.jsonb :source_data, default: {}

      t.timestamps
    end
  end
end
