class BookmarkStore < ApplicationRecord
  belongs_to :bookmark
  belongs_to :store

  validates :bookmark, uniqueness: { scope: :store_id }
end
