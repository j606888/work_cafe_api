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
        order_by: 'asc',
        ignore_hidden: true
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
          order_by: params[:order_by],
          ignore_hidden: params[:ignore_hidden]
        )
    end
  end

  describe 'POST hide_all_unqualified' do
    let!(:user) { create(:user) }

    before do
      mock_admin
      allow(StoreService::HideAllUnqualified).to receive(:call)
    end

    it "call required service" do
      post :hide_all_unqualified

      expect(StoreService::HideAllUnqualified).to have_received(:call)
    end
  end

  describe 'POST sync_photos' do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let(:params) { { id: store.place_id } }

    before do
      mock_admin
      allow(StoreService::QueryOne).to receive(:call).and_return(store)
      allow(StorePhotoService::CreateFromGoogle).to receive(:call)
    end

    it "call required service" do
      post :sync_photos, params: params

      expect(StoreService::QueryOne).to have_received(:call)
        .with(place_id: store.place_id)
      expect(StorePhotoService::CreateFromGoogle).to have_received(:call)
        .with(store_id: store.id)
    end
  end
end
