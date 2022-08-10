require 'rails_helper'

RSpec.describe Admin::StoresController, type: :controller do
  describe 'GET :index' do
    let!(:user) { create(:user) }
    let(:stores) { build_list :store, 3 }
    let(:params) do
      {
        page: 2,
        per: 2,
        cities: ['台南市'],
        rating: 3.5,
        order: 'desc',
        order_by: 'asc'
      }
    end

    before do
      mock_admin
      allow(StoreService::Query).to receive(:call).and_return(stores)
    end

    it "pass params to service" do
      get :index, params: params

      expect(response.status).to eq(200)
      expect(StoreService::Query).to have_received(:call)
        .with(
          page: params[:page],
          per: params[:per],
          cities: params[:cities],
          rating: params[:rating],
          order: params[:order],
          order_by: params[:order_by]
        )
    end
  end
end
