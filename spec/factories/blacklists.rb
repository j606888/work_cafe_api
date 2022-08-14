FactoryBot.define do
  factory :blacklist do
    sequence(:keyword) {|n| "五十嵐-#{n}" }
  end
end
