FactoryBot.define do
  factory :store do
    sequence(:name) {|n| "Store-#{n}" }
    sequence(:url) {|n| "https://store-#{n}.com" }
  end
end
