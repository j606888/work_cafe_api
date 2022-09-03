class BookmarkStore < ApplicationRecord
  belongs_to :bookmark
  belongs_to :store
end
