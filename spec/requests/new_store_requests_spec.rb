require 'rails_helper'

RSpec.describe "NewStoreRequests", type: :request do
  describe "POST /new-store-requests" do
    let!(:user) { create :user }
    let(:params) do
      {
        content: 'Yoyo street'
      }
    end

    it "create a new_store_requests" do
      post "/new-store-requests", params: params, headers: stub_auth(user)

      expect(response.status).to eq(200)
      new_store_request = NewStoreRequest.last
      expect(new_store_request.user).to eq(user)
      expect(new_store_request.content).to eq(params[:content])
    end
  end
end
