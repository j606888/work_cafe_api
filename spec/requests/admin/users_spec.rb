require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /admin/users" do
    let!(:users) { create_list :user, 3 }
    let(:params) do
      {
        page: 1,
        per: 3
      }
    end

    it "return users" do
      get "/admin/users", params: params, headers: stub_admin(users[0])

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      res_hash['users'].reverse.each_with_index do |res_user, index|
        user = users[index]
        expect_data = user.as_json(except: [:password])
        expect(res_user).to eq(expect_data)
      end
      expect(res_hash['paging']).to eq({
        'current_page' => 1,
        'total_pages' => 1,
        'total_count' => 3
      })
    end
  end
end
