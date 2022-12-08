require 'rails_helper'

describe StoreService::BuildSearchHint do
  def build_store(name, city, district)
    create :store, name: name, city: city, district: district
  end
  let!(:stores) do
    [
      build_store('鹿柴咖啡', '台南市', '中西區'),
      build_store('鴨母聊', '台南市', '中西區'),
      build_store('一家咖啡', '台南市', '中西區'),
      build_store('桃憩咖啡', '台南市', '中西區'),
      build_store('露地 茶x空間', '台南市', '中西區'),
      build_store('橘子水漾', '台南市', '東區'),
      build_store('蔛菟 HU TU', '台南市', '東區'),
      build_store(' 上看書bRidge+', '台南市', '東區'),
      build_store(' 汀咖啡館', '台北市', '大安區'),
      build_store(' 淬咖啡店', '台北市', '松山區'),
    ]
  end
  let(:params) do
    {
      keyword: 'some-city'
    }
  end
  let(:service) { described_class.new(**params) }

  before do
    allow(StoreService::QueryByLocation).to receive(:call)
      .and_return({stores: []})
  end

  it 'takes required attributes to initialize' do
    described_class.new(**params)
  end

  it 'return [] if nothing match' do
    res = service.perform

    expect(res).to eq([])
  end

  it 'match district' do
    params[:keyword] = "東"

    res = service.perform

    expect(res.length).to eq(1)
    expect(res.last).to eq(described_class::SearchResult.new('district', '東區', '台南市', nil, 3))
  end

  it 'match city' do
    params[:keyword] = "台"

    res = service.perform

    expect(res.length).to eq(2)
    expect(res[0]).to eq(described_class::SearchResult.new('city', '台南市', nil, nil, 8))
    expect(res[1]).to eq(described_class::SearchResult.new('city', '台北市', nil, nil, 2))
  end

  it 'build from QueryByLocation' do
    allow(StoreService::QueryByLocation).to receive(:call).and_return({ stores: [stores[1]] } )
    params[:keyword] = "鴨母"
    params[:lat] = 23.0183537
    params[:lng] = 120.2548569

    res = service.perform

    expect(res.length).to eq(1)
    expect(res.last).to eq(described_class::SearchResult.new('store', '鴨母聊', stores[1].address, stores[1].place_id, 1))
    expect(StoreService::QueryByLocation).to have_received(:call)
      .with(
        lat: 23.0183537,
        lng: 120.2548569,
        per: 5,
        keyword: "鴨母",
        open_type: 'NONE'
      )
  end

  context 'when opening_hours exist' do
    let(:saturday) { Time.new(2022, 8, 13, 15, 0, 0, "+08:00") }

    def create_open_time(store, weekday, open_time, close_time)
      create :opening_hour, {
        store: store,
        open_day: weekday,
        close_day: weekday,
        open_time: open_time,
        close_time: close_time
      }
    end

    before do
      create_open_time(stores[0], 6, '0800', '1200')
      create_open_time(stores[1], 6, '1200', '1800')
      create_open_time(stores[2], 6, '1200', '1600')

      allow(Time).to receive(:now).and_return(saturday)
    end

    it 'query open_now stores' do
      params[:keyword] = "台"
      params[:open_type] = 'OPEN_NOW'

      res = service.perform

      expect(res.length).to eq(1)
      expect(res[0]).to eq(described_class::SearchResult.new('city', '台南市', nil, nil, 2))
    end

    it 'query open_week stores' do
      params[:keyword] = "台"
      params[:open_type] = "OPEN_AT"
      params[:open_week] = 6
      params[:open_hour] = 15

      res = service.perform

      expect(res.length).to eq(1)
      expect(res[0]).to eq(described_class::SearchResult.new('city', '台南市', nil, nil, 2))
    end
  end
end
