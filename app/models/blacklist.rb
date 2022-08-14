class Blacklist < ApplicationRecord
  validates :keyword, presence: true
  validates :keyword, uniqueness: true

  def self.keywords
    self.all.pluck(:keyword)
  end
end
