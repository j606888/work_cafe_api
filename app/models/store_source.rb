class StoreSource < ApplicationRecord
  include AASM

  VALID_CREATE_TYPE = ['user', 'admin']

  validates_uniqueness_of :place_id
  validates_inclusion_of :create_type, in: VALID_CREATE_TYPE

  aasm do
    state :created, initial: true
    state :binded, :rejected

    event :do_bind do
      transitions from: :created, to: :binded
    end
  
    event :do_rejected do
      transitions from: :created, to: :rejected
    end
  end
end
