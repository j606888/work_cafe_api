class Bookmark < ApplicationRecord
  VALID_CATEGORIES = ['favorite', 'interest', 'custom']

  belongs_to :user

  validates :category, inclusion: { in: VALID_CATEGORIES }

  before_validation :create_random_key, on: :create

  private

  def create_random_key
    loop do
      self.random_key = SecureRandom.hex(5)
      break unless self.class.exists?(random_key: random_key)
    end
  end
end
