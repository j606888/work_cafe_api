class CreateStorePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :store_photos do |t|
      t.references :store, null: false, foreign_key: true
      t.string :random_key, null: false
      t.string :image_url, null: false
      t.string :photo_reference

      t.timestamps
    end
  end
end
