class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.string :external_id, null: false
      t.string :address
      t.string :phone
      t.boolean :location_lat
      t.boolean :location_lng
      t.boolean :rating
      t.string :url, null: false
      t.string :website
      t.string :user_ratings_total
      t.jsonb :source_data, default: {}

      t.timestamps
    end
  end
end
