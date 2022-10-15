require 'rails_helper'

RSpec.describe "Report", type: :request do
  describe "GET /admin/report/dashboard" do
    let!(:users) { create_list :user, 10 }
    let!(:stores) { create_list :store, 7 }
    let!(:store_photos) do
      stores[..2].map do |store|
        create :store_photo, store: store
      end
    end
    let!(:reviews) do
      users[..3].map do |user|
        create :review, user: user, store: stores[3]
      end
    end

    it "return users" do
      get "/admin/report/dashboard", headers: stub_admin(users[0])

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)

      expect(res_hash).to eq({
        "user_count" => 10,
        "store_count" => 7,
        "store_photo_count" => 3,
        "review_count" => 4
      })
    end
  end
end
