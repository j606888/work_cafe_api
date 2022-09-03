FactoryBot.define do
  factory :bookmark do
    association :user
    name { "喜愛的店" }
    type { "favorite" }
  end
end
