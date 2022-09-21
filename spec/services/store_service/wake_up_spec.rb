require 'rails_helper'

describe StoreService::WakeUp do
  let!(:store) { create :store }
  let(:params) do
    {
      store_id: store.id
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      store_id: 'abc123'
    )
  end

  it 'wake up a store' do
    expect(store.wake_up).to be(false)

    service.perform

    expect(store.reload.wake_up).to be(true)
  end

  it 'raise error if store not found' do
    params[:store_id] = 'wrong-place-id'

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
