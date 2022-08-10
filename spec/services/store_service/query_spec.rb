require 'rails_helper'

describe StoreService::Query do
  let!(:stores) { create_list :store, 20 }
  let(:params) do
    {
      page: 1,
      per: 10
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new
  end

  it 'return stores with order created_at DESC' do
    res = service.perform
    
    expect(res.length).to eq(10)
    expect(res).to eq(stores.reverse[0..9])
  end

  it "raise error if per over 100" do
    params[:per] = 101
    
    expect { service.perform }.to raise_error(Service::PerformFailed)
  end

  context 'when cities is provide' do
    before do
      stores[0].update!(city: '台南市')
      stores[1].update!(city: '台北市')
      stores[2].update!(city: '高雄市')
      stores[3].update!(city: '台南市')
      stores[4].update!(city: '桃園市')
    end

    it 'return specified cities' do
      params[:cities] = ['台南市', '高雄市']

      res = service.perform

      expect(res.length).to eq(3)
      expect(res.map(&:id)).to eq([stores[0], stores[2], stores[3]].reverse.map(&:id))
    end
  end

  context 'when rating is provide' do
    before do
      stores[0].update!(rating: 1)
      stores[1].update!(rating: 2.5)
      stores[2].update!(rating: 2.7)
      stores[3].update!(rating: 3.6)
      stores[4].update!(rating: 4.6)
      stores[5].update!(rating: 4.9)
    end

    it 'return over_rating' do
      params[:rating] = 4.5

      res = service.perform

      expect(res.length).to eq(2)
      expect(res.map(&:id)).to eq([stores[4], stores[5]].reverse.map(&:id))
    end
  end

  context 'when order is provide' do
    it 'order desc' do
      params[:order] = 'desc'

      res = service.perform

      expect(res.map(&:id)).to eq(stores.reverse[0..9].map(&:id))
    end

    it 'order asc' do
      params[:order] = 'asc'

      res = service.perform

      expect(res.map(&:id)).to eq(stores[0..9].map(&:id))
    end

    it 'raise error if order invalid' do
      params[:order] = 'super'

      expect { service.perform }.to raise_error(Service::PerformFailed)
    end
  end

  context 'when order_by is provide' do
    before do
      stores[0].update!(user_ratings_total: 30)
      stores[1].update!(user_ratings_total: 10)
      stores[2].update!(user_ratings_total: 20)
    end

    it 'order_by user_ratings_total and nulls last' do
      params[:order_by] = 'user_ratings_total'

      res = service.perform

      expect(res[0..2].map(&:id)).to eq([stores[0], stores[2], stores[1]].map(&:id))
    end

    it 'raise error if order_by is invalid' do
      params[:order_by] = "magic"

      expect { service.perform }.to raise_error(Service::PerformFailed)
    end
  end
end
