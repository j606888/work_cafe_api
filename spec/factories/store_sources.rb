FactoryBot.define do
  factory :store_source do
    association :store
    source_data { {} }
  end
end
