FactoryBot.define do
  factory :store_photo do
    association :store
    sequence(:photo_reference) {|n| "ref-#{n}" }
    sequence(:image_url) {|n| "https://image-#{n}.com" }
  end
end
