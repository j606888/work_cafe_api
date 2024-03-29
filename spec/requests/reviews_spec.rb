require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "POST /stores/:store_id/reviews" do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let(:store_id) { store.place_id }
    let(:params) do
      {
        recommend: 'no',
        description: 'Horrible cafe ever',
        visit_day: 'weekday'
      }
    end

    it "create a new review" do
      post "/stores/#{store_id}/reviews", params: params, headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)

      review = Review.last
      expect(res_hash['id']).to eq(review.id)
      expect(review.user).to eq(user)
      expect(review.store).to eq(store)
      expect(review.recommend).to eq('no')
      expect(review.description).to eq('Horrible cafe ever')
      expect(review.visit_day).to eq('weekday')
    end
  end

  describe 'GET /stores/:store_id/reviews' do
    let!(:users) { create_list :user, 5 }
    let!(:store) { create :store }
    let!(:tags) { create_list :tag, 3, primary: true }
    let!(:reviews) do
      users.map do |user|
        review = create :review, store: store, user: user
        tags.each do |tag|
          create :store_review_tag, store: store, review: review, tag: tag
        end

        review
      end
    end
    let(:store_id) { store.place_id }

    it "retrieve reviews from store" do
      get "/stores/#{store_id}/reviews"

      expect(response.status).to eq(200)

      res_hash = JSON.parse(response.body)
      expect(res_hash['reviews'].length).to eq(5)
      res_hash['reviews'].each do |review|
        expect(review['primary_tags']).to eq(tags.map(&:name))
        expect(review['secondary_tags']).to eq([])
        expect(review['photos']).to eq([])
      end
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

  describe 'GET /stores/:store_id/reviews/me' do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let!(:review) { create :review, user: user, store: store }

    it 'retrieve review if exist' do
      get "/stores/#{store.place_id}/reviews/me", headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash['id']).to eq(review.id)
    end

    it 'retrieve nil if review not exist' do
      review.delete

      get "/stores/#{store.place_id}/reviews/me", headers: stub_auth(user)

      expect(response.status).to eq(200)
      res_hash = JSON.parse(response.body)
      expect(res_hash).to be_nil
    end
  end

  describe 'DELETE /stores/:store_id/reviews' do
    let!(:user) { create :user }
    let!(:store) { create :store }
    let!(:review) { create :review, user: user, store: store }

    it 'delete review if exist' do
      delete "/stores/#{store.place_id}/reviews", headers: stub_auth(user)

      expect(response.status).to eq(200)
      expect(Review.count).to eq(0)
    end
  end
end
