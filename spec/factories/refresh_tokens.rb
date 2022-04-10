FactoryBot.define do
  factory :refresh_token do
    user { nil }
    token { "MyString" }
    is_valid { false }
  end
end
