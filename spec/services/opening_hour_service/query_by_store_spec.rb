require 'rails_helper'

describe OpeningHourService::QueryByStore do
  let!(:store) { create :store }
  let(:params) do
    {
      store_id: store.id 
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

  it 'takes required attributes to initialize' do
    described_class.new(
      store_id: 1
    )
  end

  it 'returns default format' do
    res = service.perform

    expect(res).to eq([
      { label: '星期日', periods: [], weekday: 0 },
      { label: '星期一', periods: [], weekday: 1 },
      { label: '星期二', periods: [], weekday: 2 },
      { label: '星期三', periods: [], weekday: 3 },
      { label: '星期四', periods: [], weekday: 4 },
      { label: '星期五', periods: [], weekday: 5 },
      { label: '星期六', periods: [], weekday: 6 }
    ])
  end

  context 'when opening_hours exist' do
    before do
      build_opening_hours([
        [0, "0900", "1200"],
        [0, "1800", "2200"],
        [1, "0900", "1200"],
        [1, "1800", "2200"],
      ])
    end

    it 'returns formatted opening_hours' do
      res = service.perform

      expect(res).to eq([
        {
          label: '星期日',
          weekday: 0,
          periods: [
            { start: '09:00', end: '12:00' },
            { start: '18:00', end: '22:00' }
          ]
        },
        {
          label: '星期一',
          weekday: 1,
          periods: [
            { start: '09:00', end: '12:00' },
            { start: '18:00', end: '22:00' }
          ]
        },
        { label: '星期二', periods: [], weekday: 2 },
        { label: '星期三', periods: [], weekday: 3 },
        { label: '星期四', periods: [], weekday: 4 },
        { label: '星期五', periods: [], weekday: 5 },
        { label: '星期六', periods: [], weekday: 6 }
      ])
    end
  end

  it 'raise error if store not found' do
    store.delete

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
