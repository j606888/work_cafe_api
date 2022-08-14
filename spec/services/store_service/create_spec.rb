require 'rails_helper'

describe StoreService::Create do
  def mock_place_detail
    allow(GoogleMapPlace).to receive(:detail).and_return(double(**place_detail))
  end
  let(:place_id) { 'ChIJ7fkKoZN2bjQRl6TdcFGT-vo' }
  let(:service) { described_class.new(place_id: place_id) }
  let(:place_detail) do
    {
      place_id: place_id,
      name: '粟木小火鍋 台南東寧店',
      address: '701台灣台南市東區東寧路350號',
      phone: '0937 331 390',
      url: 'https://maps.google.com/?cid=14250860131006162248',
      website: "https://iding.tw/stores/2f3ff78d/menu",
      rating: 4.5,
      user_ratings_total: 101,
      lat: 22.9898379,
      lng: 120.227883,
      city: '台南市',
      district: '東區',
      open_periods: ['some-periods'],
      data: 'all-data',
      permanently_closed: false
    }
  end

  before do
    mock_place_detail
    allow(OpeningHourService::Create).to receive(:call)
    allow(StoreService::FetchPhoto).to receive(:call)
  end

  it "required valid argument to call" do
    described_class.new(place_id: place_id)
  end

  it "call GoogleMapPlace.detail" do
    service.perform

    expect(GoogleMapPlace).to have_received(:detail)
      .with(place_id)
  end

  it "create store" do
    store = service.perform
    expect(store.place_id).to eq(place_id)
    expect(store.name).to eq(place_detail[:name])
    expect(store.address).to eq(place_detail[:address])
    expect(store.phone).to eq(place_detail[:phone])
    expect(store.url).to eq(place_detail[:url])
    expect(store.website).to eq(place_detail[:website])
    expect(store.rating).to eq(place_detail[:rating])
    expect(store.user_ratings_total).to eq(place_detail[:user_ratings_total])
    expect(store.lat).to eq(place_detail[:lat])
    expect(store.lng).to eq(place_detail[:lng])
    expect(store.city).to eq(place_detail[:city])
    expect(store.district).to eq(place_detail[:district])
  end
  
  it "create store_source" do
    store = service.perform

    expect(store.store_source.source_data).to eq(place_detail[:data])
  end

  it "create opening_hours" do
    store = service.perform

    expect(OpeningHourService::Create).to have_received(:call)
      .with(store_id: store.id)
  end

  it "fetch photo" do
    store = service.perform

    expect(StoreService::FetchPhoto).to have_received(:call)
      .with(store_id: store.id)
  end

  it "raise error if place_id exist" do
    create :store, place_id: place_id

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end

  context "when fetch detail failed" do
    before do
      place_detail[:data] = nil
      mock_place_detail
    end

    it "raise error" do
      expect { service.perform }.to raise_error(Service::PerformFailed)
    end
  end
end
