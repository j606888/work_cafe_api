FactoryBot.define do
  factory :bookmark do
    association :user
    sequence(:name) {|n| "喜愛的店-#{n}" }
    category { "custom" }
  end
end
