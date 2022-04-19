class MapCrawler < ApplicationRecord
  include AASM

  has_one :store, as: :sourceable

  aasm do
    state :created, initial: true
    state :accept, :deny

    event :do_accept do
      transitions from: :created, to: :accept
    end

    event :do_deny do
      transitions from: :created, to: :deny
    end
  end
end