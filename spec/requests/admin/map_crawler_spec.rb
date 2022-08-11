require 'rails_helper'

RSpec.describe "MapCrawler", type: :request do
  describe "POST /admin/map-crawlers" do
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
      allow(StoreService::FetchPhoto).to receive(:call)
    end

    it "create map_url" do
      post "/admin/map-crawlers", params: params, headers: stub_admin(user)

      expect(response.status).to eq(200)
    end
  end
end
