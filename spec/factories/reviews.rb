FactoryBot.define do
  factory :review do
    association :user
    association :store
    recommend { "yes" }
    room_volume { "loud" }
    time_limit { "weekend" }
    socket_supply { "yes" }
    description { "There's cute cats inside" }
  end
end
