class Store < ApplicationRecord
  has_many :opening_hours, dependent: :delete_all
  belongs_to :sourceable, polymorphic: true

  validates :name, :url, presence: true

  VALID_SOURCEABLE_TYPE = ['MapUrl', 'MapCrawler']
end
