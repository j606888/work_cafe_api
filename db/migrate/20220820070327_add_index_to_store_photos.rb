class AddIndexToStorePhotos < ActiveRecord::Migration[7.0]
  def change
    add_index :store_photos, :photo_reference, unique: true
  end
end
