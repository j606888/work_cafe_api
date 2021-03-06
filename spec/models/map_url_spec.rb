require 'rails_helper'

RSpec.describe MapUrl, type: :model do
  it { is_expected.to validate_inclusion_of(:decision).in_array(described_class::VALID_DECISIONS) }

  it "should validate uniqueness of [:url, :user_id]" do
    user_1 = FactoryBot.create :user
    user_2 = FactoryBot.create :user

    map_url = FactoryBot.create :map_url, user: user_1

    valid = FactoryBot.build :map_url, {
      user: user_2,
      url: map_url.url
    }
    expect(valid).to be_valid

    invalid = FactoryBot.build :map_url, {
      user: user_1,
      url: map_url.url
    }
    expect(invalid).not_to be_valid
  end
end
