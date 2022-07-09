require 'rails_helper'

describe MapCrawlerService::Create do
  def mock_google_place_cafe
    allow(GoogleMapPlace).to receive(:cafe_search).and_return(double(**mock_cafe_search))
  end
  let!(:user) { create :user }
  let(:params) do
    {
      user_id: user.id,
      lat: 22.9994438,
      lng: 120.2048099,
      radius: 1000
    }
  end
  let(:mock_cafe_search) do
    {
      places: [
        {:place_id=>"ChIJKQvNlYl2bjQRGZCMHUi--u4", :name=>"Gan Dan Cafe"},
        {:place_id=>"ChIJM6N9rGB2bjQRkY1hO7ff48A", :name=>"Golden Tulip Glory Fine Hotel Tainan"},
        {:place_id=>"ChIJQVhy5GB2bjQRbCKCXlnzXX0", :name=>"卡加米亞casamia cafe"}
      ],
      next_page: nil
    }
  end
  let(:service) { described_class.new(**params) }

  before do
    mock_google_place_cafe
    allow(StoreService::Create).to receive(:call)
  end

  it "required valid arguments to call" do
    described_class.new(
      user_id: user.id,
      lat: 2.34,
      lng: 1.23,
      radius: 3000
    )
  end

  it "call GoogleMapPlace#nearbysearch" do
    service.perform

    expect(GoogleMapPlace).to have_received(:cafe_search)
      .with(
        location: "22.9994438,120.2048099",
        radius: 1000
      )
  end

  it "call StoreService::Create with the return list" do
    service.perform

    expect(StoreService::Create).to have_received(:call).with(place_id: 'ChIJKQvNlYl2bjQRGZCMHUi--u4')
    expect(StoreService::Create).to have_received(:call).with(place_id: 'ChIJM6N9rGB2bjQRkY1hO7ff48A')
    expect(StoreService::Create).to have_received(:call).with(place_id: 'ChIJQVhy5GB2bjQRbCKCXlnzXX0')
  end

  it "create MapCrawler" do
    map_crawler = service.perform

    expect(map_crawler.user_id).to eq(user.id)
    expect(map_crawler.lat).to eq(22.9994438)
    expect(map_crawler.lng).to eq(120.2048099)
    expect(map_crawler.radius).to eq(1000)
    expect(map_crawler.total_found).to eq(3)
    expect(map_crawler.new_store_count).to eq(3)
    expect(map_crawler.repeat_store_count).to eq(0)
    expect(map_crawler.blacklist_store_count).to eq(0)
  end

  context "when store_name is blacklist" do
    before do
      mock_cafe_search[:places][0][:name] = "台南中華鮮自然"
      mock_google_place_cafe
    end

    it "count as #blacklist_store_count" do
      map_crawler = service.perform

      expect(map_crawler.total_found).to eq(3)
      expect(map_crawler.new_store_count).to eq(2)
      expect(map_crawler.repeat_store_count).to eq(0)
      expect(map_crawler.blacklist_store_count).to eq(1)
    end
  end

  context "when store#place_id already exist" do
    before do
      create :store, place_id: 'ChIJKQvNlYl2bjQRGZCMHUi--u4'
    end

    it "count as #repeat_store_count" do
      map_crawler = service.perform

      expect(map_crawler.total_found).to eq(3)
      expect(map_crawler.new_store_count).to eq(2)
      expect(map_crawler.repeat_store_count).to eq(1)
      expect(map_crawler.blacklist_store_count).to eq(0)
    end
  end

  context "when next_page exist" do
    before do
      mock_cafe_search[:next_page] = double(
        places: [
          {:place_id=>"ChIJhwhoW2N2bjQRsQRMoD4STa4", :name=>"Shuangquan Black Tea"},
          {:place_id=>"ChIJxRCBpYx2bjQRC4PhjOObSjY", :name=>"Tian Zaixin Cafe"},
          {:place_id=>"ChIJyeyC9It2bjQRJ3ooaDY30IU", :name=>"STARBUCKS Tainan Shop"}
        ],
        next_page: nil
      )
      mock_google_place_cafe
    end

    it "create more stores" do
      map_crawler = service.perform

      expect(map_crawler.total_found).to eq(6)
      expect(map_crawler.new_store_count).to eq(6)
      expect(map_crawler.repeat_store_count).to eq(0)
      expect(map_crawler.blacklist_store_count).to eq(0)
    end
  end
end
