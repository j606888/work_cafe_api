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
            'type' => 'store',
            'name' => '台南鹿柴咖啡',
            'address' => stores[0].address,
            'place_id' => stores[0].place_id,
            'count' => 1
          },
          {
            'type' => 'city',
            'name' => '台南市',
            'address' => nil,
            'place_id' => nil,
            'count' => 4
          }
        ]
      })
    end
  end
end
