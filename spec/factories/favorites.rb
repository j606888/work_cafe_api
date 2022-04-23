FactoryBot.define do
  factory :favorite do
    association :user 
    association :store
  end
end
