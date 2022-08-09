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
    end
  end
end
