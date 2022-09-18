require 'rails_helper'

describe StorePhotoService::Query do
  let!(:user) { create :user }
  let!(:stores) { create_list :store, 10 }
  let!(:store_photo_groups) do
    stores.map do |store|
      g = create :store_photo_group, store: store, user: user
      3.times do
        create :store_photo, store: store, user: user, store_photo_group: g
      end

      g
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

  it 'return store_photo_groups' do
    res = service.perform

    expect(res.map(&:id)).to eq(store_photo_groups.reverse.map(&:id))
  end
end
