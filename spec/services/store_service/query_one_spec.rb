require 'rails_helper'

describe StoreService::QueryOne do
  let!(:store) { create :store }
  let(:params) do
    {
      place_id: store.place_id
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      place_id: 'abc123'
    )
  end

  it 'return store' do
    res = service.perform

    expect(res).to eq(store)
  end

  it 'raise error if store not found' do
    params[:place_id] = 'wrong-place-id'

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
