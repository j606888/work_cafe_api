require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  describe "POST /bookmarks" do
    let!(:user) { create :user }
    let(:params) do
      {
        name: '週末咖啡'
      }
    end

    it 'create a new bookmark' do
      post "/bookmarks", params: params, headers: stub_admin(user)

      expect(response.status).to eq(200)
      bookmark = Bookmark.last
      expect(bookmark.user).to eq(user)
      expect(bookmark.name).to eq(params[:name])
      expect(bookmark.category).to eq('custom')
    end
  end
end
