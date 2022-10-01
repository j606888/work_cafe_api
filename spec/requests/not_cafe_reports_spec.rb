require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "POST /stores/:store_id/not-cafe-reports" do
    let!(:store) { create :store }
    let!(:user) { create :user }
    let(:store_id) { store.place_id }

    it "create a new not_cafe_report" do
      post "/stores/#{store_id}/not-cafe-reports"

      expect(response.status).to eq(200)

      not_cafe_report = NotCafeReport.last
      expect(not_cafe_report.store).to eq(store)
    end

    it "create a new not_cafe_report with user" do
      post "/stores/#{store_id}/not-cafe-reports", headers: stub_auth(user)

      expect(response.status).to eq(200)

      not_cafe_report = NotCafeReport.last
      expect(not_cafe_report.user).to eq(user)
      expect(not_cafe_report.store).to eq(store)
    end
  end
end
