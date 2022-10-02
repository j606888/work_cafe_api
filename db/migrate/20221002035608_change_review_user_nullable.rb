class ChangeReviewUserNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :reviews, :user_id, true
  end
end
