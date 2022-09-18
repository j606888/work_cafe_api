class StorePhoto < ApplicationRecord
  belongs_to :store
  belongs_to :user, optional: true
  belongs_to :store_photo_group, optional: true

  before_validation :create_random_key, on: :create

  private

  def create_random_key
    return if random_key.present?

    loop do
      self.random_key = SecureRandom.hex(8)
      break unless self.class.exists?(random_key: random_key)
    end
  end
end
