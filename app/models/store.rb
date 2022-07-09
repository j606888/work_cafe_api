class Store < ApplicationRecord
  has_many :opening_hours, dependent: :delete_all
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user
  has_many :hiddens
  has_many :hidden_users, through: :hiddens, source: :user
  has_one :store_source

  validates :name, :url, presence: true
end
