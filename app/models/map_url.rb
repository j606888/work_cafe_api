class MapUrl < ApplicationRecord
  VALID_DECISIONS = %w[blacklist search_fail success rejected waiting]
 
  belongs_to :user

  validates_uniqueness_of :url, scope: :user_id
  validates :decision, inclusion: { in: VALID_DECISIONS }
end
