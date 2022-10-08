class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false, index: { unique: true }
      t.boolean :primary, null: false, default: false

      t.timestamps
    end
  end
end
