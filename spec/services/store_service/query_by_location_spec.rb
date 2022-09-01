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

  it 'ignore hidden stores' do
    stores[0].update!(hidden: true)
    stores[1].update!(hidden: true)

    res = service.perform

    expect(res).to eq([stores[3], stores[2]])
  end

  context 'when keyword provide' do
    it "search for keyword stores" do
      params[:keyword] = stores[0].name
      
      res = service.perform
      
      expect(res).to eq([stores[0]])
    end
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
      params[:open_type] = 'open_now'

      res = service.perform

      expect(res.length).to eq(2)
      expect(res.first.id).to eq(stores[1].id)
      expect(res.last.id).to eq(stores[2].id)
    end

    it 'query open_at stores with open_week' do
      params[:open_type] = 'open_at'
      params[:open_week] = 6

      res = service.perform

      expect(res.length).to eq(3)
    end

    it 'query open_at stores with open_week and open_hour' do
      params[:open_type] = 'open_at'
      params[:open_week] = 6
      params[:open_hour] = 9

      res = service.perform

      expect(res.length).to eq(1)
      expect(res.first.id).to eq(stores[0].id)
    end
  end

  context 'when mode is #address' do
    before do
      stores[0].update!(city: '台南市')
      stores[1].update!(name: '台南好市多')
      stores[2].update!(city: '台南市')
      stores[3].update!(name: '台南縣')

      params[:mode] = 'address'
      params[:keyword] = '台南市'
    end

    it 'match stores by city or district' do
      res = service.perform

      expect(res.length).to eq(2)
      expect(res.map(&:id)).to eq([stores[0].id, stores[2].id])
    end
  end

  context 'when #user_id exist' do
    let!(:user) { create :user }

    before do
      create :user_hidden_store, user: user, store: stores[0]
      create :user_hidden_store, user: user, store: stores[2]
      params[:user_id] = user.id
    end

    it 'filter out hidden stores' do
      res = service.perform

      expect(res.length).to eq(2)
      expect(res.map(&:id)).to eq([stores[3].id, stores[1].id])
    end
  end
end
