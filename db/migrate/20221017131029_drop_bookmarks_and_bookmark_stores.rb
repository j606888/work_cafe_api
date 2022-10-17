class DropBookmarksAndBookmarkStores < ActiveRecord::Migration[7.0]
  def change
    drop_table :bookmark_stores
    drop_table :bookmarks
  end
end
