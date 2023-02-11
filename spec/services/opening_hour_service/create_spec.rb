require 'rails_helper'

describe OpeningHourService::Create do
  let!(:store) { create :store }
  let!(:store_source) do
    create :store_source, {
      store: store,
      source_data: {
        "opening_hours": {
          "periods": [
            {
              "open": { "day": 0, "time": "1100" },
              "close": { "day": 0, "time": "1400" }
            },
            {
              "open": { "day": 0, "time": "1700" },
              "close": { "day": 0, "time": "2300" }
            },
            {
              "open": { "day": 1, "time": "1100" },
              "close": { "day": 1, "time": "1400" }
            },
            {
              "open": { "day": 2, "time": "1700" },
              "close": { "day": 2, "time": "2300" }
            }
          ]
        }
      }
    }
  end
  let(:service) { described_class.new(store_id: store.id) }

  it "required valid argument to call" do
    described_class.new(store_id: store.id)
  end

  it "create opening_hours" do
    service.perform

    expect(OpeningHour.count).to eq(4)
    expect(OpeningHour.all.pluck(:open_day, :open_time, :close_day, :close_time)).to match_array(
      [
        [0, "1100", 0, "1400"],
        [0, "1700", 0, "2300"],
        [1, "1100", 1, "1400"],
        [2, "1700", 2, "2300"]
      ]
    )
  end

  context "when opening_hour is blank" do
    before do
      store_source.update!(
        source_data: {
          opening_hours: {
            periods: []
          }
        }
      )
    end

    it "won't create any records" do
      service.perform

      expect(OpeningHour.count).to eq(0)
    end
  end

  context "when store never close" do
    before do
      store_source.update!(
        source_data: {
          opening_hours: {
            periods: [
              {
                "open": { "day": 0, "time": "0000" }
              }
            ]
          }
        }
      )
    end

    it "create with one record" do
      service.perform

      opening_hour = OpeningHour.last
      expect(opening_hour.open_day).to eq(0)
      expect(opening_hour.open_time).to eq("0000")
      expect(opening_hour.close_day).to be_nil
      expect(opening_hour.close_time).to be_nil
    end
  end

  it "raise error if store not exist" do
    store.destroy

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "raise error if store_source not exist" do
    store_source.delete

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
