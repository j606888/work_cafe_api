FactoryBot.define do
  factory :new_store_request do
    association :user
    content { "some-google-map-url" }
  end
end
