require 'rails_helper'

RSpec.describe Admin::MapCrawlersController, type: :controller do
  describe 'POST :create' do
    let!(:user) { create(:user) }
    let!(:map_crawler) { build(:map_crawler) }
    let(:params) do
      {
        lat: 23.011885,
        lng: 120.1993492,
        radius: 500
      }
    end

    before do
      mock_admin
      allow(MapCrawlerService::Create).to receive(:call).and_return(map_crawler)
    end

    it "pass params to service" do
      post :create, params: params

      expect(response.status).to eq(200)
      expect(MapCrawlerService::Create).to have_received(:call)
        .with(
          user_id: user.id,
          lat: params[:lat],
          lng: params[:lng],
          radius: params[:radius]
        )
    end
  end

  describe 'GET :index' do
    let!(:user) { create(:user) }
    let!(:map_crawlers) { build_list(:map_crawler, 3) }
    let(:params) do
      {
        lat: 23.011885,
        lng: 120.1993492
      }
    end

    before do
      mock_admin
      allow(MapCrawlerService::Query).to receive(:call).and_return(map_crawlers)
    end

    it "pass params to service" do
      get :index, params: params

      expect(response.status).to eq(200)
      expect(MapCrawlerService::Query).to have_received(:call)
        .with(
          lat: params[:lat],
          lng: params[:lng]
        )
    end
  end
end
