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

  describe 'GET :location' do
    let!(:user) { create(:user) }
    let(:stores) { build_list :store, 3 }
    let(:params) do
      {
        lat: 23.003043,
        lng: 120.216569,
        limit: 5,
        open_type: 'open_at',
        open_week: 6,
        open_hour: 15,
        wake_up: true
      }
    end

    before do
      mock_user
      stores.each { |store| create :store_source, store: store }
      allow(StoreService::QueryByLocation).to receive(:call).and_return(stores)
      allow(OpeningHourService::IsOpenNowMap).to receive(:call).and_return({})
    end

    it "pass params to service" do
      get :location, params: params

      expect(response.status).to eq(200)
      expect(StoreService::QueryByLocation).to have_received(:call)
        .with(
          user_id: user.id,
          mode: 'address',
          lat: params[:lat],
          lng: params[:lng],
          limit: params[:limit],
          open_type: params[:open_type],
          open_week: params[:open_week],
          open_hour: params[:open_hour],
          wake_up: params[:wake_up]
        )
      expect(OpeningHourService::IsOpenNowMap).to have_received(:call)
        .with(store_ids: stores.map(&:id))
    end
  end

  describe 'POST :hide' do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let(:params) do
      {
        id: store.place_id
      }
    end

    before do
      mock_user
      allow(StoreService::QueryOne).to receive(:call).and_return(store)
      allow(UserHiddenStoreService::Create).to receive(:call)
    end

    it "create user_hidden_store" do
      post :hide, params: params

      expect(response.status).to eq(200)
      expect(StoreService::QueryOne).to have_received(:call)
        .with(place_id: store.place_id)
      expect(UserHiddenStoreService::Create).to have_received(:call)
        .with(
          user_id: user.id,
          store_id: store.id
        )
    end
  end

  describe 'GET :hidden' do
    let!(:user) { create :user }
    let!(:stores) { create_list :store, 5 } 
    
    before do
      mock_user
      allow(UserHiddenStoreService::QueryStores).to receive(:call).and_return(stores)
      allow(OpeningHourService::IsOpenNowMap).to receive(:call).and_return({})
    end

    it "return hidden_stores" do
      get :hidden

      expect(response.status).to eq(200)
      expect(UserHiddenStoreService::QueryStores).to have_received(:call)
        .with(user_id: user.id)
      expect(OpeningHourService::IsOpenNowMap).to have_received(:call)
        .with(store_ids: stores.map(&:id))
    end
  end
end
