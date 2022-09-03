require 'rails_helper'

describe BookmarkStoreService::Create do
  let!(:store) { create :store }
  let!(:bookmark) { create :bookmark }
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

  it 'create a new bookmark_store' do
    res = service.perform

    expect(res).to eq(BookmarkStore.last)
    expect(res.store).to eq(store)
    expect(res.bookmark).to eq(bookmark)
  end

  it 'raise error if bookmark_store duplicate' do
    BookmarkStore.create!(
      store: store,
      bookmark: bookmark
    )

    expect { service.perform }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
