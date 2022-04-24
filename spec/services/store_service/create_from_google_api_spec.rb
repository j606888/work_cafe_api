require 'rails_helper'

describe StoreService::CreateFromGoogleApi do
  describe '::new()' do
    it 'init with desired parameters' do
      described_class.new(
        source_type: 'MapUrl',
        source_id: 1
      )
    end 
  end

  describe '#perform' do
    let!(:map_url) { FactoryBot.create :map_url }
    let(:service) { described_class.new(source_type: 'MapUrl', source_id: map_url.id) }
    let(:google_service) do
      json_path = Rails.root.join('spec', 'helper', 'place_detail.json')
      file = File.read(json_path)
      data_hash = JSON.parse(file)

      double(place_detail: data_hash)
    end

    before do
      allow(GoogleMap).to receive(:new).and_return(google_service)
    end

    it 'update mar_url source' do
      service.perform
    
      store = Store.last
      expect(store.sourceable).to eq(map_url)
      expect(store.name).to eq("粟木小火鍋 台南東寧店")
      expect(store.url).to eq("https://maps.google.com/?cid=14250860131006162248")
      expect(store.lat).to eq(22.9898379)
      expect(store.lng).to eq(120.227883)
      expect(store.city).to eq("台南市")
      expect(store.district).to eq("東區")
    end
  end
end
