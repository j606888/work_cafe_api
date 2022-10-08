class Review < ApplicationRecord
  VALID_RECOMMENDS = ['yes', 'normal', 'no']
  VALID_ROOM_VOLUMES = ['quiet', 'normal', 'loud']
  VALID_TIME_LIMITS = ['yes', 'weekend', 'no']
  VALID_SOCKET_SUPPLIES = ['yes', 'rare', 'no']

  belongs_to :user, optional: true
  belongs_to :store
  has_many :store_review_tags

  validates :recommend, presence: true, inclusion: { in: VALID_RECOMMENDS }
  validates :room_volume, inclusion: { in: VALID_ROOM_VOLUMES }, allow_nil: true
  validates :time_limit, inclusion: { in: VALID_TIME_LIMITS }, allow_nil: true
  validates :socket_supply, inclusion: { in: VALID_SOCKET_SUPPLIES }, allow_nil: true
  validates :user_id, uniqueness: { scope: :store_id }, if: -> { user_id.present? }

  after_commit :refresh_store_summary

  private

  def refresh_store_summary
    StoreSummaryService::Refresh.call(store_id: store_id)
  end
end
