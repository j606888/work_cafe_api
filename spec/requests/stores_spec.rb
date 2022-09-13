require 'rails_helper'

RSpec.describe "Stores", type: :request do
  describe "GET /stores/hint" do
    let!(:user) { create :user }
    def build_store(name, city, district)
      create :store, name: name, city: city, district: district
    end
    let!(:stores) do
      [
        build_store('台南鹿柴咖啡', '台南市', '中西區'),
        build_store('橘子水漾', '台南市', '東區'),
        build_store('蔛菟 HU TU', '台南市', '東區'),
        build_store(' 上看書bRidge+', '台南市', '東區'),
        build_store(' 汀咖啡館', '台北市', '大安區'),
        build_store(' 淬咖啡店', '台北市', '松山區'),
      ]
    end
    let(:params) do
      {
        keyword: '台南'
      }
    end

    it "return hint hashes" do
      get "/stores/hint", params: params, headers: stub_admin(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash).to eq({
        'results' => [
          {
            'type' => 'city',
            'name' => '台南市',
            'address' => nil,
            'place_id' => nil,
            'count' => 4
          },
          {
            'type' => 'store',
            'name' => '台南鹿柴咖啡',
            'address' => stores[0].address,
            'place_id' => stores[0].place_id,
            'count' => 1
          }
        ]
      })
    end
  end

  describe "GET /stores/:id" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let!(:store_photos) do
      create_list :store_photo, 5, {
        store: store
      }
    end
    let(:saturday) { Time.new(2022, 8, 13, 15, 0, 0, "+08:00") }
    let(:id) { store.place_id }

    def create_opening_hours(weekday, periods)
      create :opening_hour, {
        store: store,
        open_day: weekday,
        open_time: periods[0],
        close_day: weekday,
        close_time: periods[1]
      }
    end

    before do
      create :store_source, store: store
      create_opening_hours(0, ['0900', '1200'])
      create_opening_hours(0, ['1500', '1800'])
      create_opening_hours(1, ['0900', '1800'])
      allow(Time).to receive(:now).and_return(saturday)
    end

    it "return store with opening hours" do
      get "/stores/#{id}"

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash['id']).to eq(store.id)
      expect(res_hash['place_id']).to eq(store.place_id)
      expect(res_hash['opening_hours']).to eq([
        {
          "label"=>"星期日",
          "periods"=>[{"start"=>"09:00", "end"=>"12:00"}, {"start"=>"15:00", "end"=>"18:00"}]
        },
        {
          "label"=>"星期一",
          "periods"=>[{"start"=>"09:00", "end"=>"18:00"}]
        },
        {"label"=>"星期二", "periods"=>[]},
        {"label"=>"星期三", "periods"=>[]},
        {"label"=>"星期四", "periods"=>[]},
        {"label"=>"星期五", "periods"=>[]},
        {"label"=>"星期六", "periods"=>[]}
      ])
      expect(res_hash['is_open_now']).to be(false)
      expect(res_hash['photos']).to eq(store_photos.map(&:image_url))
      expect(res_hash['reviews']).to eq([])
    end
  end

  describe "POST /stores/:id/hide" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let(:id) { store.place_id }

    it "create user_hidden_store" do
      post "/stores/#{id}/hide", headers: stub_auth(user)

      expect(response.status).to eq(200)
      user_hidden_store = UserHiddenStore.last
      expect(user_hidden_store.user).to eq(user)
      expect(user_hidden_store.store).to eq(store)
    end
  end

  describe "GET /stores/:hidden" do
    let!(:user) { create :user }
    let!(:stores) { create_list :store, 5 }
    
    before do
      create :user_hidden_store, user: user, store: stores[0]
      create :user_hidden_store, user: user, store: stores[3]
    end

    it "retrieve hidden stores" do
      get "/stores/hidden", headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash.length).to eq(2)
      expect(res_hash[0]['id']).to eq(stores[0].id)
      expect(res_hash[1]['id']).to eq(stores[3].id)
    end
  end

  describe "POST /stores/:id/bookmarks/:bookmark_random_key" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let!(:bookmark) { create :bookmark, user: user }
    let(:id) { store.place_id }
    let(:bookmark_random_key) { bookmark.random_key }

    it "add store to bookmark" do
      post "/stores/#{id}/bookmarks/#{bookmark_random_key}", headers: stub_auth(user)

      expect(response.status).to eq(200)
      bookmark_store = BookmarkStore.last
      expect(bookmark_store.store).to eq(store)
      expect(bookmark_store.bookmark).to eq(bookmark)
    end
  end

  describe "DELETE /stores/:id/bookmarks/:bookmark_random_key" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let!(:bookmark) { create :bookmark, user: user }
    let!(:bookmark_store) { create :bookmark_store, store: store, bookmark: bookmark }
    let(:id) { store.place_id }
    let(:bookmark_random_key) { bookmark.random_key }

    it "remove a store from bookmark" do
      expect(BookmarkStore.count).to eq(1)

      delete "/stores/#{id}/bookmarks/#{bookmark_random_key}", headers: stub_auth(user)

      expect(BookmarkStore.count).to eq(0)
    end
  end

  describe "GET /stores/:id/bookmarks" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let!(:bookmarks) { create_list :bookmark, 5, user: user }
    let(:id) { store.place_id }

    before do
      bookmarks.each do |bookmark|
        create :bookmark_store, bookmark: bookmark, store: store
      end
    end

    it "return bookmarks with #is_saved" do
      get "/stores/#{id}/bookmarks", headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash.length).to eq(5)
      res_hash.each do |bookmark_res|
        expect(bookmark_res['is_saved']).to be(true)
      end
    end
  end

end