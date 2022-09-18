class AddStorePhotoGroupIdToStorePhoto < ActiveRecord::Migration[7.0]
  def change
    add_reference :store_photos, :store_photo_group, foreign_key: true
  end
end
