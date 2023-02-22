class AddVisitDayToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :visit_day, :string
  end
end
