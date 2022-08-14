require 'rails_helper'

describe StoreService::QueryByLocation do
  it 'init with desired parameters' do
    described_class.new(
      lat: 23.03192,
      lng: 120.24213
    )
  end

  let!(:stores) do
    locations = [
      [22.9811008, 120.2163941],
      [23.0004588, 120.1984473],
      [22.9990311, 120.19648],
      [22.9829323, 120.2165171]
    ]

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
    res = service.perform

    expect_res = [
      stores[0],
      stores[3],
      stores[1],
      stores[2],
    ]

    expect(res).to eq(expect_res)
  end

  it 'limit by params[:limit]' do
    params[:limit] = 2
    res = service.perform

    expect(res.length).to eq(2)
    expect(res).to eq([stores[0], stores[3]])
  end

  it 'return with distance' do
    res = service.perform

    expect(res.map(&:distance)).to eq([0, 204, 2833, 2855])
  end
end
