class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.references :map_url, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address
      t.string :phone
      t.string :url, null: false
      t.string :website
      t.float :rating
      t.integer :user_ratings_total
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
