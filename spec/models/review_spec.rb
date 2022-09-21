require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:store) }
  it { is_expected.to validate_inclusion_of(:recommend).in_array(described_class::VALID_RECOMMENDS) }
  it { is_expected.to validate_inclusion_of(:room_volume).in_array(described_class::VALID_ROOM_VOLUMES) }
  it { is_expected.to validate_inclusion_of(:time_limit).in_array(described_class::VALID_TIME_LIMITS) }
  it { is_expected.to validate_inclusion_of(:socket_supply).in_array(described_class::VALID_SOCKET_SUPPLIES) }

  it "validate unique for user & store" do
    user = create :user
    store = create :store

    review = create :review, user: user, store: store
    invalid = build :review, user: user, store: store

    expect(invalid).not_to be_valid
  end

  it "refresh store_summary after commit" do
    store = create :store
    create :review, {
      store: store,
      recommend: 'yes',
      time_limit: 'no'
    }
    store_summary = store.store_summary
    expect(store_summary.recommend_yes).to eq(1)
    expect(store_summary.recommend_no).to eq(0)
    expect(store_summary.time_limit_yes).to eq(0)
    expect(store_summary.time_limit_no).to eq(1)
  end
end
