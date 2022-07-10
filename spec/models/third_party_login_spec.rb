require 'rails_helper'

RSpec.describe ThirdPartyLogin, type: :model do
  it { is_expected.to validate_inclusion_of(:provider).in_array(described_class::VALID_PROIVDERS) }
  it { is_expected.to validate_presence_of(:email) }

  it "should validate uniqueness of [:user_id, :provider]" do
    user = create :user
    third_party_login = create :third_party_login, user: user
    
    invalid = build :third_party_login, {
      user: third_party_login.user,
      email: third_party_login.email
    }
    expect(invalid).not_to be_valid
  end
end
