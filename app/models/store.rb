class Store < ApplicationRecord
  belongs_to :sourceable, polymorphic: true
  has_many :opening_hours, dependent: :delete_all
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user

  validates :name, :url, presence: true

  VALID_SOURCEABLE_TYPE = ['MapUrl', 'MapCrawler']
end
