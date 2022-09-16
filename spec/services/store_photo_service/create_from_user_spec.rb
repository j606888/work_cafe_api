require 'rails_helper'

describe StorePhotoService::CreateFromUser do
  let!(:user) { create :user }
  let!(:store) { create :store }
  let(:params) do
    {
      user_id: user.id,
      store_id: store.id,
      random_key: 'abc123',
      url: "https://some-s3-bucket.com/stores/#{store.place_id}/abc123.jpeg"
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      user_id: 1,
      store_id: 2,
      random_key: 'abc123',
      url: "some-url"
    )
  end

  it 'create a store_photo from input' do
    res = service.perform
    expect(res.user).to eq(user)
    expect(res.store).to eq(store)
    expect(res.random_key).to eq(params[:random_key])
    expect(res.image_url).to eq(params[:url])
  end

  it 'raise error if user not found' do
    user.delete

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'raise error if store not found' do
    store.delete

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'raise error if url not contained store#place_id' do
    params[:url] = 'some-bad-link'

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
