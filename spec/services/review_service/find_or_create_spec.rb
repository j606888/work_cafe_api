require 'rails_helper'

describe ReviewService::FindOrCreate do
  let!(:user) { create :user }
  let!(:store) { create :store }
  let(:params) do
    {
      user_id: user.id,
      store_id: store.id,
      recommend: 'yes',
      room_volume: 'quiet',
      time_limit: 'no',
      socket_supply: 'yes',
      description: 'Have cute cate'
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      user_id: 1,
      store_id: 2,
      recommend: 'normal'
    )
  end

  it 'create new review' do
    review = service.perform

    expect(review.user).to eq(user)
    expect(review.store).to eq(store)
    expect(review.recommend).to eq('yes')
    expect(review.room_volume).to eq('quiet')
    expect(review.time_limit).to eq('no')
    expect(review.socket_supply).to eq('yes')
    expect(review.description).to eq('Have cute cate')
  end

  it 'raise error if create failed' do
    params[:socket_supply] = 'So many'

    expect { service.perform }.to raise_error(ActiveRecord::RecordInvalid)
  end

  context 'when user review already exist' do
    let!(:review) do
      create :review, {
        user: user,
        store: store,
        recommend: 'no',
        room_volume: 'loud'
      }
    end

    it 'update that review' do
      service.perform

      expect(Review.count).to eq(1)
      review.reload
      expect(review.recommend).to eq('yes')
      expect(review.room_volume).to eq('quiet')
    end
  end
end
