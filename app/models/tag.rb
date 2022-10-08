class Tag < ApplicationRecord
  validates :name, uniqueness: true

  has_many :store_review_tags
end
