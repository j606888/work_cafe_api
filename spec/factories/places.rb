FactoryBot.define do
  factory :place do
    name { "A room" }
    external_id { "abc123" }
    url { "https://google.map.com" }
  end
end
