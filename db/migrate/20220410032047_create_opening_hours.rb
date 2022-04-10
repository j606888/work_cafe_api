class CreateOpeningHours < ActiveRecord::Migration[7.0]
  def change
    create_table :opening_hours do |t|
      t.references :place, null: false, foreign_key: true
      t.integer :open_day, null: false
      t.string :open_time, null: false, limit: 10
      t.integer :close_day, null: false
      t.string :close_time, null: false, limit: 10

      t.timestamps
    end
  end
end
