class CreateNotCafeReports < ActiveRecord::Migration[7.0]
  def change
    create_table :not_cafe_reports do |t|
      t.references :user, null: true, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
