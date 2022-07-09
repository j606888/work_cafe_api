class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :place_id, null: false
      t.string :name, null: false
      t.string :address
      t.string :phone
      t.string :url, null: false
      t.string :website
      t.float :rating
      t.integer :user_ratings_total
      t.string :image_url
      t.float :lat
      t.float :lng

      t.timestamps

      t.index :place_id, unique: true
    end
  end
end
