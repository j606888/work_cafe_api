require 'rails_helper'

RSpec.describe "MapCrawler", type: :request do
  describe "POST /admin/map_crawlers" do
    let!(:user) { create :user }
    let(:params) do
      {
        lat: 23.546162,
        lng: 120.6402133,
        radius: 500
      }
    end

    before do
      nearbysearch = File.read('spec/fixtures/google_map_nearbysearch.json')
      stub_request(:post, "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
        .with(query: hash_including({}))
        .to_return(body: nearbysearch, headers: { content_type: 'application/json'})

      detail = File.read('spec/fixtures/google_map_detail.json')
      stub_request(:post, "https://maps.googleapis.com/maps/api/place/details/json")
        .with(query: hash_including({}))
        .to_return(body: detail, headers: { content_type: 'application/json'})
    end

    it "create map_url" do
      post "/admin/map_crawlers", params: params, headers: stub_admin(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash['user_id']).to eq(user.id)
      expect(res_hash['lat']).to eq(23.546162)
      expect(res_hash['lng']).to eq(120.6402133)
      expect(res_hash['radius']).to eq(500)
      expect(res_hash['total_found']).to eq(1)
      expect(res_hash['new_store_count']).to eq(1)
      expect(res_hash['repeat_store_count']).to eq(0)
      expect(res_hash['blacklist_store_count']).to eq(0)
    end
  end
end
