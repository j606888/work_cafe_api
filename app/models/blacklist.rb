class Blacklist < ApplicationRecord
  validates :keyword, presence: true
  validates :keyword, uniqueness: true
end
