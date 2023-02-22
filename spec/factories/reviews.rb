FactoryBot.define do
  factory :review do
    association :user
    association :store
    recommend { "yes" }
    description { "There's cute cats inside" }
    visit_day { "weekday" }
  end
end
