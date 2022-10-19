class RemoveUnusedColumnsFromReviews < ActiveRecord::Migration[7.0]
  def change
    remove_column :reviews, :room_volume
    remove_column :reviews, :time_limit
    remove_column :reviews, :socket_supply
  end
end
