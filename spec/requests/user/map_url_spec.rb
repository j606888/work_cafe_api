require 'rails_helper'

RSpec.describe "MapUrl", type: :request do
  describe "POST /user/map_urls" do
    let!(:user) { create :user }
    let(:url) { "https://www.google.com.tw/maps/place/%E9%B4%A8%E6%AF%8D%E8%81%8A%C2%B7%E4%BA%9E%E6%8D%B7%E5%92%96%E5%95%A1/@23.0001479,120.2014808,17z/data=!4m5!3m4!1s0x346e766047027bf7:0xf8569392721c7cc4!8m2!3d23.000143!4d120.2036748?hl=zh-TW" }
    let(:nearbysearch) {  }
    let(:detail) {  }

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
      post "/user/map_urls", params: { url: url }, headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      
      expect(res_hash['user_id']).to eq(user.id)
      expect(res_hash['url']).to eq(url)
      expect(res_hash['keyword']).to eq('鴨母聊·亞捷咖啡')
      expect(res_hash['place_id']).to eq('ChIJ93sCR2B2bjQRxHwccpKTVvg')
      expect(res_hash['decision']).to eq('success')
    end
  end
end
