require 'rails_helper'

describe StorePhotoService::CreateFromUser do
  let!(:user) { create :user }
  let!(:store) { create :store }
  let!(:review) { create :review, store: store, user: user }
  let(:params) do
    {
      user_id: user.id,
      store_id: store.id,
      review_id: review.id,
      url: "https://some-s3-bucket.com/stores/#{store.place_id}/abc123.jpeg"
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      user_id: 1,
      store_id: 2,
      review_id: 3,
      url: "some-url"
    )
  end

  it 'create a store_photo from input' do
    res = service.perform
    expect(res.user).to eq(user)
    expect(res.store).to eq(store)
    expect(res.review).to eq(review)
    expect(res.random_key).to eq('abc123')
    expect(res.image_url).to eq(params[:url])
  end

  it 'raise error if user not found' do
    user.destroy

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'raise error if store not found' do
    store.destroy

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'raise error if url not contained store#place_id' do
    params[:url] = 'some-bad-link'

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end

  it 'support none user' do
    dummy_review = create :review, store: store
    params[:user_id] = nil
    params[:review_id] = dummy_review.id

    res = service.perform

    expect(res.user_id).to be_nil
    expect(res.review).to eq(dummy_review)
    expect(res.store).to eq(store)
  end
end
