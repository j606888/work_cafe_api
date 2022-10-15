class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :refresh_tokens, dependent: :destroy
  has_many :map_crawlers, dependent: :destroy
  has_many :map_urls, dependent: :destroy
  has_many :third_party_logins, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :user_hidden_stores
  has_many :hidden_stores, through: :user_hidden_stores, source: 'store'
  has_many :bookmarks
  has_many :store_photos
  has_many :store_photo_groups
end
