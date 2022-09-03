FactoryBot.define do
  factory :user_hidden_store do
    association :user
    association :store
  end
end
