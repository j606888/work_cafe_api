require 'rails_helper'

RSpec.describe "Stores", type: :request do
  describe "GET /admin/stores" do
    let!(:user) { create :user }
    let!(:stores) { create_list :store, 3 }
    let(:params) do
      {
        page: 1,
        per: 3
      }
    end

    it "return stores" do
      get "/admin/stores", params: params, headers: stub_admin(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      res_hash['stores'].reverse.each_with_index do |res_store, index|
        store = stores[index]
        expect_data = store.as_json
        expect(res_store).to eq(expect_data)
      end
      expect(res_hash['paging']).to eq({
        'current_page' => 1,
        'total_pages' => 1,
        'total_count' => 3
      })
    end
  end

  describe "POST /admin/stores/hide-all-unqualified" do
    let!(:user) { create :user }
    let!(:stores) { create_list :store, 5 }

    before do
      stores[0].update!(rating: 1)
    end

    it "hide stores with unqualified" do
      post "/admin/stores/hide-all-unqualified", headers: stub_admin(user)

      expect(response.status).to eq(200)
      stores[0].reload
      expect(stores[0].hidden).to be(true)
    end
  end

  describe "POST /admin/stores/:id/sync-photos" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let!(:store_source) do
      create :store_source, store: store, source_data: {
        'photos' => [
          { 'photo_reference' => 'ref-1' },
          { 'photo_reference' => 'ref-2' },
          { 'photo_reference' => 'ref-3' }
        ]
      }
    end
    let(:id) { store.place_id }

    before do
      allow(GoogleMapPlace).to receive(:photo).and_return('image-content')
      allow(Aws::S3::Client).to receive(:new).and_return(double(put_object: true))
    end

    it "sync photos" do
      post "/admin/stores/#{id}/sync-photos", headers: stub_admin(user)
      
      expect(response.status).to eq(200)
      expect(StorePhoto.count).to eq(3)
    end
  end
end
