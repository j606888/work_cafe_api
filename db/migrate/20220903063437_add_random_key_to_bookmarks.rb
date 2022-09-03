class AddRandomKeyToBookmarks < ActiveRecord::Migration[7.0]
  def change
    add_column :bookmarks, :random_key, :string, null: false
  end
end
