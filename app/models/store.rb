class Store < ApplicationRecord
  has_many :opening_hours, dependent: :delete_all
  belongs_to :map_url

  validates :name, :url, presence: true
end
