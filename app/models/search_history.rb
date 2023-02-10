class SearchHistory < ApplicationRecord
  belongs_to :user, optional: true
end
