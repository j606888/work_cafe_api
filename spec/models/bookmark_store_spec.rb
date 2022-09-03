require 'rails_helper'

RSpec.describe BookmarkStore, type: :model do
  it { should belong_to(:bookmark) }
  it { should belong_to(:store) }

  it "validate unique for bookmark & store" do
    bookmark = create :bookmark
    store = create :store

    bookmark_store = create :bookmark_store, bookmark: bookmark, store: store
    invalid = build :bookmark_store, bookmark: bookmark, store: store

    expect(invalid).not_to be_valid
  end
end
