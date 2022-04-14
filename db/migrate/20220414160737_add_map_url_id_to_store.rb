class AddMapUrlIdToStore < ActiveRecord::Migration[7.0]
  def change
    add_reference :stores, :map_url, null: false, foreign_key: true
  end
end
