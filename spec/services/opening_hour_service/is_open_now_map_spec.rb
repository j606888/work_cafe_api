require 'rails_helper'

describe OpeningHourService::IsOpenNowMap do
  let!(:stores) { create_list :store, 5 }
  let(:params) do
    {
      store_ids: stores.map(&:id)
    }
  end
  let(:service) { described_class.new(**params) }
  let(:saturday) { Time.new(2022, 8, 13, 15, 0, 0, "+08:00") }

  before do
    allow(Time).to receive(:now).and_return(saturday)
  end

  it 'takes required attributes to initialize' do
    described_class.new(store_ids: [1,2,3])
  end

  it 'default return all false' do
    res = service.perform

    expect(res).to eq(stores.map(&:id).index_with(false))
  end

  context 'when opening_hours exist' do
    def create_opening_hour(store, open_day, open_time, close_time)
      create :opening_hour, {
        store: store,
        open_day: open_day,
        close_day: open_day,
        open_time: open_time,
        close_time: close_time
      }
    end

    before do
      create_opening_hour(stores[0], 6, '1200', '1800')
      create_opening_hour(stores[1], 5, '1200', '1800')
      create_opening_hour(stores[2], 6, '0600', '1200')
      create_opening_hour(stores[3], 6, '1430', '1500')
    end

    it 'mark opening_store as true' do
      res = service.perform

      expect(res).to eq({
        stores[0].id => true,
        stores[1].id => false,
        stores[2].id => false,
        stores[3].id => true,
        stores[4].id => false,
      })
    end
  end
end
