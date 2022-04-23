FactoryBot.define do
  factory :store do
    association :resourceable, factory: :map_url
    name { "A room" }
    url { "https://google.map.com" }
  end
end
