FactoryBot.define do
  factory :third_party_login do
    association :user    
    provider { "google" }
    email { Faker::Internet.email }
  end
end
