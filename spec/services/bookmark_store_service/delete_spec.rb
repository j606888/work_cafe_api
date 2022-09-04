require 'rails_helper'

describe BookmarkStoreService::Delete do
  let!(:store) { create :store }
  let!(:bookmark) { create :bookmark }
  let!(:bookmark_store) { create :bookmark_store, store: store, bookmark: bookmark }
  let(:params) do
    {
      store_id: store.id,
      bookmark_id: bookmark.id
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      store_id: 1,
      bookmark_id: 1
    )
  end

  it 'delete bookmark_store' do
    res = service.perform

    expect(BookmarkStore.count).to eq(0)
  end

  it 'raise error if bookmark_store not exist' do
    bookmark_store.delete

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
