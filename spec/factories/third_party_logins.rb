FactoryBot.define do
  factory :third_party_login do
    association :user    
    provider { "google" }
    email { Faker::Internet.email }
    identity { '1234567890' }
  end
end
