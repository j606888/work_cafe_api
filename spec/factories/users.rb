FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  trait :admin do
    after(:create) do |user, evaluator|
      user.add_role(:admin)
    end
  end
end
