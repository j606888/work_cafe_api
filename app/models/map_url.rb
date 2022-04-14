class MapUrl < ApplicationRecord
  include AASM

  belongs_to :user
  has_one :store

  validates_uniqueness_of :url, scope: :user_id

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
