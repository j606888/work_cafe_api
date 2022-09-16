class AddUserIdToStorePhotos < ActiveRecord::Migration[7.0]
  def change
    add_reference :store_photos, :user, foreign_key: true
  end
end
