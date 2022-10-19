FactoryBot.define do
  factory :review do
    association :user
    association :store
    recommend { "yes" }
    description { "There's cute cats inside" }
  end
end
