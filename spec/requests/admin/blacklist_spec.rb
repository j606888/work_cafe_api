require 'rails_helper'

RSpec.describe "Blacklist", type: :request do
  let!(:user) { create :user }

  describe "GET /admin/blacklists" do
    let!(:blacklists) { create_list :blacklist, 5 }

    it "return blacklists" do
      get "/admin/blacklists", headers: stub_admin(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash.length).to eq(5)
      res_hash.each_with_index do |res_blacklist, index|
        blacklist = blacklists[index]
        expect_data = blacklist.as_json
        expect(res_blacklist).to eq(expect_data)
      end
    end
  end

  describe "POST /admin/blacklists" do
    let(:keyword) { "some-keyword" }
    let(:params) do
      {
        keyword: keyword
      }
    end

    it "create a new blacklist" do
      post "/admin/blacklists", params: params, headers: stub_admin(user)

      expect(response.status).to eq(200)
      blacklist = Blacklist.last
      expect(blacklist.keyword).to eq(keyword)
    end
  end

  describe "DELETE /admin/blacklists/:id" do
    let!(:blacklist) { create :blacklist }
    let(:id) { blacklist.id }

    it "delete blacklist" do
      delete "/admin/blacklists/#{id}", headers: stub_admin(user)

      expect(response.status).to eq(200)
      expect(Blacklist.count).to eq(0)
    end
  end
end
