class StorePhotoGroup < ApplicationRecord
  belongs_to :store
  belongs_to :user
  has_many :store_photos
end
