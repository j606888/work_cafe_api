FactoryBot.define do
  factory :store_review_tag do
    association :store
    association :review
    association :tag
  end
end
