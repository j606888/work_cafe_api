class CreateStoreReviewTags < ActiveRecord::Migration[7.0]
  def change
    create_table :store_review_tags do |t|
      t.references :store, null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
