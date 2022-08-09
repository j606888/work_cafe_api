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
end
