FactoryBot.define do
  factory :chain_store_map do
    association :chain_store
    association :store
  end
end
