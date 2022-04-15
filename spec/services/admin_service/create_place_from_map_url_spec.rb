require 'rails_helper'

describe AdminService::CreatePlaceFromMapUrl do
  describe '::new()' do
    it 'init with desired parameters' do
      AdminService::CreatePlaceFromMapUrl.new(
        map_url_id: 1,
        place_id: 'xxx'
      )
    end 
  end

  describe '#perform' do
    let(:google_service) do
      json_path = Rails.root.join('spec', 'helper', 'place_detail.json')
      file = File.read(json_path)
      data_hash = JSON.parse(file)

      double(place_detail: data_hash)
    end
    let(:place_id) { 'ChIJb8eDUnZ3bjQRSCVm7Mg5xcU' }
    let!(:map_url) do
      FactoryBot.create :map_url, {
        keyword: "粟木小火鍋 台南東寧店"
      }
    end
    let(:service) do
      described_class.new(
        map_url_id: map_url.id,
        place_id: place_id
      )
    end

    before(:each) do
      allow(GoogleMap).to receive(:new).and_return(google_service)
    end

    it 'should update map_url' do
      service.perform

      map_url.reload
      expect(map_url.aasm_state).to eq('accept')
      expect(map_url.place_id).to eq(place_id)
      expect(map_url.source_data).to eq(google_service.place_detail)
    end

    it 'should create store' do
      service.perform

      store = Store.last
      expect(store.map_url).to eq(map_url)
      expect(store.name).to eq(map_url.keyword)
      expect(store.address).to eq('701台灣台南市東區東寧路350號')
      expect(store.phone).to eq('0937 331 390')
      expect(store.url).to eq('https://maps.google.com/?cid=14250860131006162248')
      expect(store.website).to eq('https://iding.tw/stores/2f3ff78d/menu')
      expect(store.rating).to eq(4.5)
      expect(store.user_ratings_total).to eq(101)
      expect(store.lat).to eq(22.9898379)
      expect(store.lng).to eq(120.227883)
    end

    def opening_hour_arr(opening_hour)
      opening_hour.as_json(only: [:open_day, :open_time, :close_day, :close_time]).values
    end

    it 'should create opening_hours' do
      service.perform

      store = Store.last
      opening_hours = OpeningHour.all

      expect(opening_hours.count).to eq(14)
      expect(opening_hour_arr(opening_hours[0])).to eq([0, "1100", 0, "1400"])
      expect(opening_hour_arr(opening_hours[1])).to eq([0, "1700", 0, "2300"])
      expect(opening_hour_arr(opening_hours[12])).to eq([6, "1100", 6, "1400"])
      expect(opening_hour_arr(opening_hours[13])).to eq([6, "1700", 6, "2300"])
    end
  end
end
