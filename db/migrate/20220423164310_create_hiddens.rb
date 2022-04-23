class CreateHiddens < ActiveRecord::Migration[7.0]
  def change
    create_table :hiddens do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.string :reason

      t.timestamps
    end
  end
end
