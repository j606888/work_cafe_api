require 'rails_helper'

describe UserHiddenStoreService::Create do
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
      store_id: 1
    )
  end

  it 'create user_hidden_store' do
    res = service.perform

    expect(res.user).to eq(user)
    expect(res.store).to eq(store)
  end

  it 'raise error when duplicate' do
    service.perform

    expect { service.perform }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
