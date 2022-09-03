class Bookmark < ApplicationRecord
  VALID_CATEGORIES = ['favorite', 'interest', 'custom']

  belongs_to :user

  validates :category, inclusion: { in: VALID_CATEGORIES }
end
