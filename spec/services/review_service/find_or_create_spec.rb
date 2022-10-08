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

  context 'when user_id is not provide' do
    before do
      params[:user_id] = nil
    end

    it "create a review with no user" do
      service.perform

      review = Review.last
      expect(review.store).to eq(store)
      expect(review.user_id).to eq(nil)
    end
  end

  context 'when tag_ids is provide' do
    let!(:tags) { create_list :tag, 3 }

    before do
      params[:tag_ids] = tags.map(&:id)
    end

    it "create store_review_tags" do
      expect { service.perform }.to change { StoreReviewTag.count}.by(3)
      review = Review.last
      StoreReviewTag.all.each_with_index do |store_review_tag, index|
        expect(store_review_tag.store_id).to eq(store.id)
        expect(store_review_tag.tag_id).to eq(tags[index].id)
        expect(store_review_tag.review_id).to eq(review.id)
      end
    end
  end
end
