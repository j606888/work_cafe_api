FactoryBot.define do
  factory :store do
    sequence(:place_id) {|n| "place-id-#{n}" }
    sequence(:name) {|n| "Store-#{n}" }
    sequence(:url) {|n| "https://store-#{n}.com" }
  end
end
