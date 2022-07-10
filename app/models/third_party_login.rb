class ThirdPartyLogin < ApplicationRecord
  VALID_PROIVDERS = ["google"]

  belongs_to :user

  validates :provider, inclusion: { in: VALID_PROIVDERS }
  validates :email, presence: true
  validates_uniqueness_of :user_id, scope: [:provider, :email]
end
