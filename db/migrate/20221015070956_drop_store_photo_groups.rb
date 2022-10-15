class DropStorePhotoGroups < ActiveRecord::Migration[7.0]
  def change
    remove_column :store_photos, :store_photo_group_id
    drop_table :store_photo_groups
  end
end
