FactoryBot.define do
  factory :bookmark_store do
    association :bookmark
    association :store
  end
end
