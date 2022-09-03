FactoryBot.define do
  factory :bookmark do
    association :user
    name { "喜愛的店" }
    category { "favorite" }
  end
end
