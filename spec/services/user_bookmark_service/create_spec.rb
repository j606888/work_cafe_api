require 'rails_helper'

describe UserBookmarkService::Create do
  let!(:user) { create :user }
  let!(:store) { create :store }
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
      store_id: 2
    )
  end

  it 'create new user_bookmark' do
    res = service.perform

    expect(res).to eq(UserBookmark.last)
    expect(res.user).to eq(user)
    expect(res.store).to eq(store)
  end
end
