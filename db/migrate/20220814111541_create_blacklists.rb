class CreateBlacklists < ActiveRecord::Migration[7.0]
  def change
    create_table :blacklists do |t|
      t.string :keyword, null: false, unique: true

      t.timestamps
    end
  end
end
