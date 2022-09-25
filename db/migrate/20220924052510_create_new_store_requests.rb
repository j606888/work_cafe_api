class CreateNewStoreRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :new_store_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :content, null: false
      t.boolean :done, default: false, null: false

      t.timestamps
    end
  end
end
