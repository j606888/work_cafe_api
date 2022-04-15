require 'rails_helper'

describe StoreService::SearchByLocation do
  describe '::new()' do
    it 'init with desired parameters' do
      StoreService::SearchByLocation.new(
        lat: 23.03192,
        lng: 120.24213,
        zoom: 18
      )
    end
  end

  describe '#perform' do
    let(:lat) { 23.03192 }
    let(:lng) { 120.24213 }
    let!(:nearby_stores) do
      3.times.map do |i|
        FactoryBot.create :store, {
          lat: lat + 0.001 * i,
          lng: lng - 0.001 * i
        }
      end
    end
    let!(:far_stores) do
      5.times.map do |i|
        FactoryBot.create :store, {
          lat: lat + 0.001 * i + 0.04,
          lng: lng - 0.001 * i
        }
      end
    end
    let(:service) do
      described_class.new(
        lat: lat,
        lng: lng
      )
    end

    it 'should only query the nearby store' do
      res = service.perform

      expect(res.length).to eq(3)
      expect(res).to eq(nearby_stores)
    end
  end
end
