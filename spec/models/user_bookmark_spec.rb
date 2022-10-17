require 'rails_helper'

RSpec.describe UserBookmark, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:store) }

  it "should validate uniqueness of [:user_id, :store_id]" do
    user_bookmark = create :user_bookmark

    invalid = build :user_bookmark, {
      user: user_bookmark.user,
      store: user_bookmark.store
    }
    expect(invalid).not_to be_valid
  end
end
