class RefreshToken < ApplicationRecord
  belongs_to :user

  validates :token, uniqueness: true

  before_validation :set_token

  private
  def set_token
    self.token = SecureRandom.hex
  end
end
