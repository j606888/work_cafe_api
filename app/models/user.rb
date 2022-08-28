class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :refresh_tokens, dependent: :destroy
  has_many :map_crawlers, dependent: :destroy
  has_many :map_urls, dependent: :destroy
  has_many :third_party_logins, dependent: :destroy
end
