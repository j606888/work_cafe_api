require 'rails_helper'

describe ReviewService::Delete do
  let!(:user) { create :user }
  let!(:store) { create :store }
  let!(:review) { create :review, user: user, store: store }
  let(:params) do
    {
      user_id: user.id,
      store_id: store.id
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      user_id: 1,
      store_id: 1
    )
  end

  it "delete review" do
    service.perform

    expect(Review.count).to eq(0)
  end
end
