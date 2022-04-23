FactoryBot.define do
  factory :hidden do
    association :user 
    association :store
    reason { "Price" }
  end
end
