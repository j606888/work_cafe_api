require 'rails_helper'

describe ReviewService::Query do
  let!(:users) { create_list :user, 10 }
  let!(:store) { create :store }
  let!(:reviews) do
    users.map do |user|
      create :review, store: store, user: user
    end
  end
  let(:params) { {} }
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new()
  end

  it 'fetch reviews' do
    res = service.perform

    expect(res.length).to eq(10)
    res.each_with_index do |review, index|
      expect(review).to eq(reviews.reverse[index])
    end
  end

  context 'when store_id is provide' do
    let!(:store2) { create :store }

    before do
      reviews[0].update!(store: store2)
      reviews[3].update!(store: store2)
      reviews[6].update!(store: store2)

      params[:store_id] = store2.id
    end

    it 'only retrieve specify stores' do
      res = service.perform

      expect(res.length).to eq(3)
      expect(res.pluck(:id)).to eq([reviews[6], reviews[3], reviews[0]].map(&:id))
    end
  end
end
