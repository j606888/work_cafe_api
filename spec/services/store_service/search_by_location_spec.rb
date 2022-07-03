require 'rails_helper'

describe StoreService::SearchByLocation do
  describe '::new()' do
    it 'init with desired parameters' do
      StoreService::SearchByLocation.new(
        lat: 23.03192,
        lng: 120.24213,
        max_distance: 3000
      )
    end
  end

  describe '#perform' do
    let(:locations) do
      [
        [22.9811008, 120.2163941],
        [23.0004588, 120.1984473],
        [22.9990311, 120.19648],
        [22.9829323, 120.2165171]
      ]
    end
    let!(:stores) do
      locations.map do |location|
        create :store, lat: location.first, lng: location.last
      end
    end
    let(:params) do
      {
        lat: 22.9811008,
        lng: 120.2163941
      }
    end
    let(:service) { described_class.new(**params) }

    it 'query nearby stores' do
      params[:max_distance] = 2000

      res = service.perform

      expect(res.length).to eq(2)
    end

    it 'return list with distance sorted' do
      res = service.perform

      expect(res.map(&:distance)).to eq([0, 204, 2833, 2855])
    end
  end
end
