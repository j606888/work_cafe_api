require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  describe 'get :hint' do
    let(:params) do
      {
        lat: 123,
        lng: 456,
        keyword: 'cafe'
      }
    end

    before do
      allow(StoreService::BuildSearchHint).to receive(:call).and_return([])
    end

    it "pass params to services" do
      get :hint, params: params

      expect(response.status).to eq(200)
      expect(StoreService::BuildSearchHint).to have_received(:call)
        .with(
          lat: params[:lat],
          lng: params[:lng],
          keyword: params[:keyword],
        )
    end
  end
end
