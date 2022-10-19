class Review < ApplicationRecord
  VALID_RECOMMENDS = ['yes', 'normal', 'no']

  belongs_to :user, optional: true
  belongs_to :store
  has_many :store_review_tags, dependent: :delete_all
  has_many :tags, through: :store_review_tags
  has_many :store_photos

  validates :recommend, presence: true, inclusion: { in: VALID_RECOMMENDS }
  validates :user_id, uniqueness: { scope: :store_id }, if: -> { user_id.present? }
end
