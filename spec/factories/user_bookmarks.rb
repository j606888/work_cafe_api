FactoryBot.define do
  factory :user_bookmark do
    association :user
    association :store
  end
end
