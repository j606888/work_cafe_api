FactoryBot.define do
  factory :store do
    name { "A room" }
    place_id { "abc123" }
    url { "https://google.map.com" }
  end
end
