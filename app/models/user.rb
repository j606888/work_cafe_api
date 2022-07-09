class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :refresh_tokens
  has_many :favorites
  has_many :favorite_stores, through: :favorites, source: :store
  has_many :hiddens
  has_many :hidden_stores, through: :hiddens, source: :store
  has_many :map_crawl_records
  has_many :map_urls
end
