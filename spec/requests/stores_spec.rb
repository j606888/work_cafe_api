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
end
