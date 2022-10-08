class StoreReviewTag < ApplicationRecord
  belongs_to :store
  belongs_to :review
  belongs_to :tag
end
