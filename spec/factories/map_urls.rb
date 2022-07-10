FactoryBot.define do
  factory :map_url do
    association :user
    sequence(:url) {|n| "https://www.google.com.tw/maps/place/#{n}.com" }
    decision { 'waiting' }
  end
end
