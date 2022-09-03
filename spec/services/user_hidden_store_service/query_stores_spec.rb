require 'rails_helper'

describe UserHiddenStoreService::QueryStores do
  let!(:user) { create :user }
  let!(:stores) { create_list :store, 10 }
  
  let(:params) do
    {
      user_id: user.id
    }
  end
  let(:service) { described_class.new(**params) }

  before do
    create :user_hidden_store, user: user, store: stores[0]
    create :user_hidden_store, user: user, store: stores[3]
    create :user_hidden_store, user: user, store: stores[7]
  end

  it 'takes required attributes to initialize' do
    described_class.new(user_id: 1)
  end

  it 'query hidden stores' do
    res = service.perform

    expect(res.length).to eq(3)
    expect(res.map(&:id)).to eq([stores[0].id, stores[3].id, stores[7].id])
  end
end
