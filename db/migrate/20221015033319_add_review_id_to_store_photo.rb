class AddReviewIdToStorePhoto < ActiveRecord::Migration[7.0]
  def change
    add_reference :store_photos, :review
  end
end
