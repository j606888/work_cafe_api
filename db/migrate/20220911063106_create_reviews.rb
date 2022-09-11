class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.string :recommend, null: false
      t.string :room_volume
      t.string :time_limit
      t.string :socket_supply
      t.string :description

      t.timestamps
    end
  end
end
