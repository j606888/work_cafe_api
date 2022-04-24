FactoryBot.define do
  factory :store do
    association :sourceable, factory: :map_url
    sequence(:name) {|n| "Store-#{n}" }
    sequence(:url) {|n| "https://store-#{n}.com" }
  end
end
