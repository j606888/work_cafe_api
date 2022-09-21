require 'rails_helper'

describe StoreSummaryService::Refresh do
  def create_review(recommend, room_volume, time_limit, socket_supply)
    create :review, {
      store: store,
      recommend: recommend,
      room_volume: room_volume,
      time_limit: time_limit,
      socket_supply: socket_supply
    }
  end

  let!(:store) { create :store }
  let(:params) do
    {
      store_id: store.id
    }
  end
  let(:service) { described_class.new(**params) }

  before do
    create_review('yes', 'loud', 'yes', 'rare')
    create_review('yes', 'loud', 'yes', 'rare')
    create_review('no', 'loud', 'no', 'yes')
    create_review('no', 'normal', 'weekend', 'no')
    create_review('normal', 'quite', 'weekend', 'yes')
  end

  it 'takes required attributes to initialize' do
    described_class.new(store_id: 1)
  end

  it "calculate reviews score and create summary" do
    service.perform

    store_summary = StoreSummary.last
    expect(store_summary.as_json(except: [:id, :created_at, :updated_at])).to eq({
      "store_id" => store.id,
      "recommend_yes" => 2,
      "recommend_normal" => 1,
      "recommend_no" => 2,
      "room_volume_quite" => 1,
      "room_volume_normal" => 1,
      "room_volume_loud" => 3,
      "time_limit_no" => 1,
      "time_limit_weekend" => 2,
      "time_limit_yes" => 2,
      "socket_supply_yes" => 2,
      "socket_supply_rare" => 2,
      "socket_supply_no" => 1
    })
  end

  it "update summary if exist" do
    service.perform

    expect(StoreSummary.count).to eq(1)
  end
end
