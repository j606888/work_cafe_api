require 'rails_helper'

RSpec.describe OpeningHour, type: :model do
  it { should belong_to(:store) }
  it { should validate_presence_of(:open_day) }
  it { should validate_presence_of(:open_time) }
  # it { should validate_numericality_of(:open_day).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(6) }

  it 'should validate #in_24_hour' do
    opening_hour = FactoryBot.build :opening_hour, {
      open_time: '0800',
      close_time: '2000'
    }

    expect(opening_hour).to be_valid

    opening_hour.open_time = '9999'
    expect(opening_hour).to_not be_valid

    opening_hour.open_time = '0000'
    opening_hour.close_time = '2401'
    expect(opening_hour).to_not be_valid
  end

  it 'should validate :open_day, :close_day' do
    opening_hour = FactoryBot.build :opening_hour

    expect(opening_hour).to be_valid

    opening_hour.open_day = 7
    expect(opening_hour).to_not be_valid

    opening_hour.open_day = -1
    expect(opening_hour).to_not be_valid
  end
end
