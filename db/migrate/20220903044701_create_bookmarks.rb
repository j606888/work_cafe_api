class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :category, null: false

      t.timestamps
    end
  end
end
