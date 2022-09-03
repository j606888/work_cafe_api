FactoryBot.define do
  factory :bookmark_store do
    association :user
    association :store
  end
end
