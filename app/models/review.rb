class Review < ApplicationRecord
  VALID_RECOMMENDS = ['yes', 'normal', 'no']
  VALID_VISIT_DAYS = ['weekday', 'weekend']

  belongs_to :user, optional: true
  belongs_to :store
  has_many :store_review_tags, dependent: :delete_all
  has_many :tags, through: :store_review_tags
  has_many :store_photos

  validates :recommend, presence: true, inclusion: { in: VALID_RECOMMENDS }
  validates :visit_day, presence: true, inclusion: { in: VALID_VISIT_DAYS }
  validates :user_id, uniqueness: { scope: :store_id }, if: -> { user_id.present? }

  after_create :notify_line

  private

  def notify_line
    store = self.store
    url = "#{ENV['WORK_CAFE_HOST']}/map/place/#{store.place_id}/@#{store.lat},#{store.lng},15z"
    text = <<~EOF
      <新評論>
      #{store.name}
      #{url}
    EOF
    LineBotClient.push_message(text)
  end
end
