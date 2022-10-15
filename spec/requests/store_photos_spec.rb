require 'rails_helper'

RSpec.describe "StorePhotos", type: :request do
  describe "GET /stores/:store_id/store-photos/upload-link" do
    let!(:user) { create :user }
    let!(:store) { create :store }

    it 'return a s3 url' do
      get "/stores/#{store.place_id}/store-photos/upload-link?file_extension=jpeg", headers: stub_auth(user)

      expect(response.status).to eq(200)
    end
  end

  describe "POST /stores/:store_id/store-photos" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let!(:review) { create :review }
    let!(:url) { "https://s3.com/stores/#{store.place_id}/abc123.jpeg" }
    let(:params) do
      {
        url: url,
        review_id: review.id
      }
    end

    it "create store_photo" do
      post "/stores/#{store.place_id}/store-photos", params: params, headers: stub_auth(user)

      expect(response.status).to eq(200)
      store_photo = StorePhoto.last
      expect(store_photo.user).to eq(user)
      expect(store_photo.store).to eq(store)
      expect(store_photo.random_key).to eq('abc123')
      expect(store_photo.image_url).to eq(url)
    end
  end
end
