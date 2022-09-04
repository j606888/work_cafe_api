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
      post "/bookmarks", params: params, headers: stub_auth(user)

      expect(response.status).to eq(200)
      bookmark = Bookmark.last
      expect(bookmark.user).to eq(user)
      expect(bookmark.name).to eq(params[:name])
      expect(bookmark.category).to eq('custom')
    end
  end

  describe "GET /bookmarks" do
    let!(:user) { create :user }
    let!(:bookmarks) { create_list :bookmark, 5, user: user }

    it "return bookmarks list" do
      get "/bookmarks", headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash.length).to eq(5)
      res_hash.each do |bookmark_res|
        expect(bookmark_res['is_saved']).to be(false)
      end
    end

    it "return with #is_saved" do
      store = create :store
      bookmarks.each { |b| create :bookmark_store, bookmark: b, store: store }

      get "/bookmarks", params: { place_id: store.place_id }, headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash.length).to eq(5)
      res_hash.each do |bookmark_res|
        expect(bookmark_res['is_saved']).to be(true)
      end
    end
  end

  describe "GET /bookmarks/:id" do
    let!(:user) { create :user }
    let!(:bookmark) { create :bookmark, user: user }
    let!(:stores) { create_list :store, 5 }
    let(:id) { bookmark.random_key }
    
    before do
      stores.each do |store|
        create :bookmark_store, bookmark: bookmark, store: store
      end
    end

    it "return bookmark with stores" do
      get "/bookmarks/#{id}", headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash['random_key']).to eq(bookmark.random_key)
      expect(res_hash['name']).to eq(bookmark.name)
      expect(res_hash['category']).to eq(bookmark.category)
      expect(res_hash['stores'].length).to eq(5)
      res_hash['stores'].each_with_index do |store, i|
        expect(store['place_id']).to eq(stores[i].place_id)
      end
    end
  end

  describe "DELETE /bookmarks/:id" do
    let!(:user) { create :user }
    let!(:bookmark) { create :bookmark, user: user }
    let(:id) { bookmark.random_key }

    it "delete bookmark" do
      delete "/bookmarks/#{id}", headers: stub_auth(user)

      expect(response.status).to eq(200)
      expect(Bookmark.all.count).to eq(0)
    end
  end
end
