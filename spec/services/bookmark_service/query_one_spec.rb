require 'rails_helper'

describe BookmarkService::QueryOne do
  let!(:user) { create :user }
  let!(:bookmark ) { create :bookmark, user: user }
  let(:params) do
    {
      user_id: user.id,
      bookmark_random_key: bookmark.random_key
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      user_id: 1,
      bookmark_random_key: '123abc'
    )
  end

  it 'return the bookmark' do
    res = service.perform

    expect(res).to eq(bookmark)
  end

  it 'raise error if bookmark not belongs to user' do
    params[:user_id] = user.id + 1

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
