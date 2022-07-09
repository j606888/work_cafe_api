class MapUrl < ApplicationRecord
  VALID_DECISIONS = %w[parse_failed blacklist search_fail success rejected waiting already_exist]
 
  belongs_to :user

  validates_uniqueness_of :url, scope: :user_id
  validates :decision, inclusion: { in: VALID_DECISIONS }
end
