class ChangeNullTrueForOpeningHours < ActiveRecord::Migration[7.0]
  def change
    change_column_null :opening_hours, :close_day, true
    change_column_null :opening_hours, :close_time, true
  end
end
