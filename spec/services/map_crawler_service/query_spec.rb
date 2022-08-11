require 'rails_helper'

describe MapCrawlerService::Query do
  let(:params) do
    {
      lat: 23.03192,
      lng: 120.24213,
    }
  end
  let(:service) { described_class.new(**params) }
  let!(:map_crawlers) do
    locations = [
      [22.9811008, 120.2163941],
      [23.0004588, 120.1984473],
      [22.9990311, 120.19648],
      [22.9829323, 120.2165171]
    ]

    locations.map do |location|
      create :map_crawler, lat: location.first, lng: location.last
    end
  end

  it 'takes required attributes to initialize' do
    described_class.new(
      lat: 23.03192,
      lng: 120.24213,
    )
  end

  it 'returns map_crawlers' do
    res = service.perform

    expect(res.length).to eq(4)
    expect(res.map(&:id)).to eq([map_crawlers[1],map_crawlers[2],map_crawlers[3],map_crawlers[0]].map(&:id))
  end
end
