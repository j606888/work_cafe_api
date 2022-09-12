require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "POST /stores/:store_id/reviews" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let(:store_id) { store.place_id }
    let(:params) do
      {
        recommend: 'no',
        room_volume: 'loud',
        time_limit: 'yes',
        socket_supply: 'no',
        description: 'Horrible cafe ever'
      }
    end

    it "create a new review" do
      post "/stores/#{store_id}/reviews", params: params, headers: stub_auth(user)

      expect(response.status).to eq(200)
      
      review = Review.last
      expect(review.user).to eq(user)
      expect(review.store).to eq(store)
      expect(review.recommend).to eq('no')
      expect(review.room_volume).to eq('loud')
      expect(review.time_limit).to eq('yes')
      expect(review.socket_supply).to eq('no')
      expect(review.description).to eq('Horrible cafe ever')
    end
  end

  describe 'GET /stores/:store_id/reviews' do
    let!(:users) { create_list :user, 5 }
    let!(:store) { create :store }
    let!(:reviews) do
      users.map do |user|
        create :review, store: store, user: user
      end
    end
    let(:store_id) { store.place_id }

    it "retrieve reviews from store" do
      get "/stores/#{store_id}/reviews"

      expect(response.status).to eq(200)

      res_hash = JSON.parse(response.body)
      expect(res_hash['reviews'].length).to eq(5)
    end
  end

  describe 'GET /reviews' do
    let!(:user) { create :user }
    let!(:stores) { create_list :store, 5 }
    let!(:reviews) do
      stores.map do |store|
        create :review, user: user, store: store
      end
    end

    it 'retrieve reviews with store' do
      get "/reviews", headers: stub_auth(user)

      expect(response.status).to eq(200)

      res_hash = JSON.parse(response.body)
      res_hash['reviews'].each_with_index do |review, index|
        expect(review['id']).to eq(reviews.reverse[index].id)
        expect(review['store']['place_id']).to eq(stores.reverse[index].place_id)
      end
    end
  end
end
