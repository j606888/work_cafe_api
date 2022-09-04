require 'rails_helper'

describe BookmarkService::Create do
  let!(:user) { create :user }
  let(:params) do
    {
      user_id: user.id,
      name: '週末工作'
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      user_id: 1,
      name: 'some-category'
    )
  end

  it 'create a new book_mark' do
    res = service.perform

    expect(res).to eq(Bookmark.last)
    expect(res.user).to eq(user)
    expect(res.name).to eq('週末工作')
    expect(res.category).to eq('custom')
  end
end
