class ChainStore < ApplicationRecord
  validates :name, presence: true
  has_many :chain_store_maps
  has_many :stores, through: :chain_store_maps
end
