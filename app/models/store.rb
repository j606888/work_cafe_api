class Store < ApplicationRecord
  has_many :opening_hours, dependent: :delete_all
  belongs_to :map_url

  validates :name, :place_id, :url, presence: true
  validates :place_id, uniqueness: true
end
