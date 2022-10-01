class NotCafeReport < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :store
end
