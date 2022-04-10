FactoryBot.define do
  factory :opening_hour do
    association :place
    open_day { 0 }
    open_time { "0800" }
    close_day { 0 }
    close_time { "2000" }
  end
end
