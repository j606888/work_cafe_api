FactoryBot.define do
  factory :map_crawler do
    name { "MyString" }
    aasm_state { "MyString" }
    place_id { "MyString" }
    lat { 1.5 }
    lng { 1.5 }
    source_data { "" }
  end
end
