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
        open_time: hour[1],
        close_day: hour[2],
        close_time: hour[3]
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
      { label: '星期日', periods: [], period_texts: [], weekday: 0 },
      { label: '星期一', periods: [], period_texts: [], weekday: 1 },
      { label: '星期二', periods: [], period_texts: [], weekday: 2 },
      { label: '星期三', periods: [], period_texts: [], weekday: 3 },
      { label: '星期四', periods: [], period_texts: [], weekday: 4 },
      { label: '星期五', periods: [], period_texts: [], weekday: 5 },
      { label: '星期六', periods: [], period_texts: [], weekday: 6 }
    ])
  end

  context 'when opening_hours exist' do
    before do
      build_opening_hours([
        [0, "0900", 0, "1200"],
        [0, "1800", 0, "2200"],
        [1, "0900", 0, "1200"],
        [1, "1800", 0, "2200"],
      ])
    end

    it 'returns formatted opening_hours' do
      res = service.perform

      expect(res).to eq([
        {
          label: '星期日',
          weekday: 0,
          periods: [
            { start: '09:00', close: '12:00' },
            { start: '18:00', close: '22:00' }
          ],
          period_texts: [
            "09:00 - 12:00",
            "18:00 - 22:00"
          ]
        },
        {
          label: '星期一',
          weekday: 1,
          periods: [
            { start: '09:00', close: '12:00' },
            { start: '18:00', close: '22:00' }
          ],
          period_texts: [
            "09:00 - 12:00",
            "18:00 - 22:00"
          ]
        },
        { label: '星期二', periods: [], period_texts: [], weekday: 2 },
        { label: '星期三', periods: [], period_texts: [], weekday: 3 },
        { label: '星期四', periods: [], period_texts: [], weekday: 4 },
        { label: '星期五', periods: [], period_texts: [], weekday: 5 },
        { label: '星期六', periods: [], period_texts: [], weekday: 6 }
      ])
    end
  end

  context 'when 24 hours open' do
    before do
      build_opening_hours([
        [0, "0000"]
      ])
    end

    it "return always open" do
      res = service.perform

      expect(res).to eq([
        { label: '星期日', weekday: 0, periods: [], period_texts: ["24 小時營業"] },
        { label: '星期一', weekday: 1, periods: [], period_texts: ["24 小時營業"] },
        { label: '星期二', weekday: 2, periods: [], period_texts: ["24 小時營業"] },
        { label: '星期三', weekday: 3, periods: [], period_texts: ["24 小時營業"] },
        { label: '星期四', weekday: 4, periods: [], period_texts: ["24 小時營業"] },
        { label: '星期五', weekday: 5, periods: [], period_texts: ["24 小時營業"] },
        { label: '星期六', weekday: 6, periods: [], period_texts: ["24 小時營業"] }
      ])
    end
  end

  it 'raise error if store not found' do
    store.delete

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
