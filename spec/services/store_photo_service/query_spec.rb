require 'rails_helper'

describe StorePhotoService::Query do
  let!(:user) { create :user }
  let!(:stores) { create_list :store, 10 }
  let!(:store_photos) do
    stores.map do |store|
      create :store_photo, store: store, user: user
    end
  end
  let(:params) do
    {
      user_id: user.id
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(user_id: 1)
  end

  it 'return store_photos' do
    res = service.perform

    expect(res.map(&:id)).to eq(store_photos.reverse.map(&:id))
  end
end
