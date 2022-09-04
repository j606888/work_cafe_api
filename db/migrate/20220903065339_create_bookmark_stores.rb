class CreateBookmarkStores < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmark_stores do |t|
      t.references :bookmark, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
