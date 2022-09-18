class CreateStorePhotoGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :store_photo_groups do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
