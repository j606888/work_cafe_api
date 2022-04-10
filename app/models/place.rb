class Place < ApplicationRecord
  has_many :opening_hours, dependent: :delete_all

  validates :name, :external_id, :url, presence: true
end
