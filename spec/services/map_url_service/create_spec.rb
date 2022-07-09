require 'rails_helper'

describe MapUrlService::Create do
  def mock_google_map_place
    allow(GoogleMapPlace).to receive(:nearbysearch).and_return(double(**mock_nearbysearch))
  end
  let!(:user) { create :user }
  let(:url) { "https://www.google.com.tw/maps/place/%E9%B4%A8%E6%AF%8D%E8%81%8A%C2%B7%E4%BA%9E%E6%8D%B7%E5%92%96%E5%95%A1/@23.0036324,120.2070514,16.74z/data=!4m5!3m4!1s0x346e766047027bf7:0xf8569392721c7cc4!8m2!3d23.000143!4d120.2036748?hl=zh-TW" }
  let(:params) do
    {
      user_id: user.id,
      url: url
    }
  end
  let(:service) { described_class.new(**params) }
  let(:place_id) { 'ChIJ93sCR2B2bjQRxHwccpKTVvg' }
  let(:mock_nearbysearch) do
    {
      name: '鴨母聊·亞捷咖啡',
      place_id: place_id,
      types: ["cafe", "store", "food", "point_of_interest", "establishment"],
      data: { some_data: true }
    }
  end

  before do
    mock_google_map_place
    allow(StoreService::Create).to receive(:call)
  end

  it "required valid arguments to call" do
    described_class.new(
      user_id: user.id,
      url: url
    )
  end

  it "create a MapUrl with state `success` and place_id" do
    service.perform

    expect(MapUrl.count).to eq(1)
    map_url = MapUrl.last
    expect(map_url.user_id).to eq(user.id)
    expect(map_url.url).to eq(url)
    expect(map_url.decision).to eq('success')
    expect(map_url.place_id).to eq(place_id)
  end

  it "call GoogleMapPlace#nearbysearch" do
    service.perform

    expect(GoogleMapPlace).to have_received(:nearbysearch)
      .with(
        location: '23.0036324,120.2070514',
        keyword: '鴨母聊·亞捷咖啡',
        radius: 3000
      )
  end

  it "call other service to create store" do
    service.perform

    expect(StoreService::Create).to have_received(:call)
      .with(place_id: place_id)
  end

  context "when name is blacklisted" do
    before do
      mock_nearbysearch[:name] = '台南中華85度C'
      mock_google_map_place
    end

    it "won't try to create store" do
      service.perform

      expect(StoreService::Create).not_to have_received(:call)
    end

    it "set state to `blacklist`" do
      service.perform

      map_url = MapUrl.last
      expect(map_url.decision).to eq('blacklist')
    end
  end

  context "when url is incorrect" do
    before do
      params[:url] = "https://youtube.com"
    end

    it "set decision to `parse_failed`" do
      map_url = service.perform

      expect(map_url.decision).to eq('parse_failed')
    end

    it "won't try to create store" do
      service.perform

      expect(StoreService::Create).not_to have_received(:call)
    end
  end

  context "when types is not `cafe`" do
    before do
      mock_nearbysearch[:types] = ['train station']
      mock_google_map_place      
    end

    it "set state to `waiting`" do
      map_url = service.perform

      expect(map_url.decision).to eq('waiting')
    end

    it "won't try to create store" do
      service.perform

      expect(StoreService::Create).not_to have_received(:call)
    end
  end

  context "when place_id already exist" do
    before do
      create :map_url, place_id: place_id
    end

    it "set decision to `already_exist`" do
      map_url = service.perform

      expect(map_url.decision).to eq('already_exist')
    end

    it "won't try to create store" do
      service.perform

      expect(StoreService::Create).not_to have_received(:call)
    end
  end
end
