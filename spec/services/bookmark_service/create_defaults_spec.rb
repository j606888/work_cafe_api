require 'rails_helper'

describe BookmarkService::CreateDefaults do
  let!(:user) { create :user }
  let(:params) do
    {
      user_id: user.id
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      user_id: 1
    )
  end

  it 'create default bookmarks' do
    service.perform

    bookmarks = Bookmark.where(user: user)
    expect(bookmarks.length).to eq(2)
    expect(bookmarks[0].category).to eq('favorite')
    expect(bookmarks[0].name).to eq('喜愛的地點')
    expect(bookmarks[1].category).to eq('interest')
    expect(bookmarks[1].name).to eq('想去的地點')
  end

  it 'raise error if bookmark already exist' do
    create :bookmark, user: user

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
