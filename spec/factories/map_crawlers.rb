FactoryBot.define do
  factory :map_crawler do
    association :user
    radius { 500 }
    total_found { 20 }
    new_store_count { 15 }
    repeat_store_count { 5 }
    blacklist_store_count { 0}
  end
end
