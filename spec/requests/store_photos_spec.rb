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
    let!(:url) { "https://s3.com/stores/#{store.place_id}/abc123.jpeg" }

    it "create store_photo" do
      post "/stores/#{store.place_id}/store-photos", params: { url: url }, headers: stub_auth(user)

      expect(response.status).to eq(200)
      store_photo = StorePhoto.last
      expect(store_photo.user).to eq(user)
      expect(store_photo.store).to eq(store)
      expect(store_photo.random_key).to eq('abc123')
      expect(store_photo.image_url).to eq(url)
    end
  end

  describe 'GET /store-photos' do
    let!(:user) { create :user }
    let!(:stores) { create_list :store, 5 }
    let!(:store_photos) do
      stores.map do |store|
        create :store_photo, user: user, store: store
      end
    end

    it 'retrieve store-photos with store' do
      get "/store-photos", headers: stub_auth(user)

      expect(response.status).to eq(200)

      res_hash = JSON.parse(response.body)
      res_hash['store_photos'].each_with_index do |review, index|
        expect(review['id']).to eq(store_photos.reverse[index].id)
        expect(review['store']['place_id']).to eq(stores.reverse[index].place_id)
      end
    end
  end
end
