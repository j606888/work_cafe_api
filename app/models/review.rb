class Review < ApplicationRecord
  VALID_RECOMMENDS = ['yes', 'normal', 'no']
  VALID_ROOM_VOLUMES = ['quite', 'normal', 'loud']
  VALID_TIME_LIMITS = ['yes', 'weekend', 'no']
  VALID_SOCKET_SUPPLIES = ['yes', 'rare', 'no']

  belongs_to :user
  belongs_to :store

  validates :recommend, presence: true, inclusion: { in: VALID_RECOMMENDS }
  validates :room_volume, inclusion: { in: VALID_ROOM_VOLUMES }, allow_nil: true
  validates :time_limit, inclusion: { in: VALID_TIME_LIMITS }, allow_nil: true
  validates :socket_supply, inclusion: { in: VALID_SOCKET_SUPPLIES }, allow_nil: true
  # validates :user_id, uniqueness: { scope: :store_id }
end
