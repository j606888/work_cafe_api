class StorePhotoGroup < ApplicationRecord
  belongs_to :store
  belongs_to :user
  has_many :store_photos

  validates :user, uniqueness: { scope: :store_id }
end
