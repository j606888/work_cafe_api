require 'rails_helper'

RSpec.describe "Stores", type: :request do
  describe "GET /admin/stores" do
    let!(:user) { create :user }
    let!(:stores) { create_list :store, 3 }
    let(:params) do
      {
        page: 1,
        per: 3
      }
    end

    it "return stores" do
      get "/admin/stores", params: params, headers: stub_admin(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      res_hash['stores'].reverse.each_with_index do |res_store, index|
        store = stores[index]
        expect_data = store.as_json
        expect(res_store).to eq(expect_data)
      end
      expect(res_hash['paging']).to eq({
        'current_page' => 1,
        'total_pages' => 1,
        'total_count' => 3
      })
    end
  end

  describe "GET /admin/stores/:id" do
    let!(:user) { create :user }
    let!(:store) { create :store }
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
      create_opening_hours(0, ['0900', '1200'])
      create_opening_hours(0, ['1500', '1800'])
      create_opening_hours(1, ['0900', '1800'])
      allow(Time).to receive(:now).and_return(saturday)
    end

    it "return store with opening hours" do
      get "/admin/stores/#{id}", headers: stub_admin(user)

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
    end
  end
end
