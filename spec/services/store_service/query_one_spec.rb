require 'rails_helper'

describe StoreService::QueryOne do
  let!(:store) { create :store }
  let(:params) do
    {
      place_id: store.place_id
    }
  end
  let(:service) { described_class.new(**params) }

  def build_opening_hours(hours)
    hours.map do |hour|
      create :opening_hour, {
        store: store,
        open_day: hour[0],
        close_day: hour[0],
        open_time: hour[1],
        close_time: hour[2]
      }
    end
  end
  
  before do
    build_opening_hours([
      [0, "0900", "1200"],
      [0, "1800", "2200"],
      [1, "0900", "1200"],
      [1, "1800", "2200"],
    ])
  end

  it 'takes required attributes to initialize' do
    described_class.new(
      place_id: 'abc123'
    )
  end

  it 'return store' do
    res = service.perform

    expect(res[:store]).to eq(store)
  end

  it 'return format opening_hours' do
    res = service.perform

    expect(res[:opening_hours]).to eq([
      { 
        label: '星期日',
        periods: [
          { start: '09:00', end: '12:00' },
          { start: '18:00', end: '22:00' }
        ]
      },
      { 
        label: '星期一',
        periods: [
          { start: '09:00', end: '12:00' },
          { start: '18:00', end: '22:00' }
        ]
      },
      { label: '星期二', periods: [] },
      { label: '星期三', periods: [] },
      { label: '星期四', periods: [] },
      { label: '星期五', periods: [] },
      { label: '星期六', periods: [] }
    ])
  end

  it 'raise error if store not found' do
    params[:place_id] = 'wrong-place-id'

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
