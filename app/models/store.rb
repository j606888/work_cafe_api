class Store < ApplicationRecord
  CITY_LIST = %w[台北市 新北市 桃園市 台中市 台南市 高雄市 基隆市 新竹市 嘉義市 新竹縣 苗栗縣 彰化縣 南投縣 雲林縣 嘉義縣 屏東縣 宜蘭縣 花蓮縣 臺東縣 澎湖縣 金門縣 連江縣]

  has_many :opening_hours, dependent: :delete_all
  has_many :store_photos, dependent: :destroy
  has_many :store_review_tags
  has_many :reviews, dependent: :destroy
  has_many :tags, through: :store_review_tags
  has_many :user_bookmarks
  has_one :store_source, dependent: :destroy

  validates :name, :url, presence: true

  scope :alive, -> { where(hidden: false) }

  def self.short_city_map
    CITY_LIST.each_with_object({}) do |city, memo|
      short_name = city.chars.take(2).join('')
      memo[short_name] = city
      memo
    end
  end
end
