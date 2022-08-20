class Store < ApplicationRecord
  has_many :opening_hours, dependent: :delete_all
  has_many :hiddens
  has_many :hidden_users, through: :hiddens, source: :user
  has_many :store_photos, dependent: :destroy
  has_one :store_source, dependent: :destroy

  validates :name, :url, presence: true

  scope :alive, -> { where(hidden: false) }
end
