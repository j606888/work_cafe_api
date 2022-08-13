require 'rails_helper'

describe StoreService::IsOpenNow do
  let!(:store) { create :store }
  let(:params) do
    {
      store_id: store.id
    }
  end
  let(:service) { described_class.new(**params) }
  let(:saturday) { Time.new(2022, 8, 13, 15, 0, 0, "+08:00") }

  def create_opening_hours(weekday, open_time, close_time)
    create :opening_hour, {
      store: store,
      open_day: weekday,
      open_time: open_time,
      close_day: weekday,
      close_time: close_time
    }
  end

  before do
    allow(Time).to receive(:now).and_return(saturday)
  end

  it 'takes required attributes to initialize' do
    described_class.new(store_id: 1)
  end

  it 'return false by default' do
    res = service.perform

    expect(res).to be(false)
  end

  it 'return true if in period' do
    create_opening_hours(6, '1450', '1510')

    res = service.perform

    expect(res).to be(true)
  end
end
