require 'rails_helper'

RSpec.describe User::MapUrlsController, type: :controller do
  describe 'GET :index' do
    let!(:user) { create(:user) }
    let!(:map_urls) { create_list :map_url, 5 }

    before do
      mock_user
      allow(MapUrlService::Query).to receive(:call).and_return(map_urls)
    end

    it "pass params to service" do
      get :index

      expect(response.status).to eq(200)
      expect(MapUrlService::Query).to have_received(:call)
        .with(
          user_id: user.id
        )
    end
  end
  
  describe 'POST :create' do
    let!(:user) { create(:user) }
    let!(:map_url) { build(:map_url) }
    let(:params) do
      {
        url: 'some-url'
      }
    end

    before do
      mock_user
      allow(MapUrlService::Create).to receive(:call).and_return(map_url)
    end

    it "pass params to service" do
      post :create, params: params

      expect(response.status).to eq(200)
      expect(MapUrlService::Create).to have_received(:call)
        .with(
          user_id: user.id,
          url: params[:url]
        )
    end
  end
end
