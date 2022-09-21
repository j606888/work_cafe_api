require 'rails_helper'

describe StoreService::ReviewReport do
  let!(:users) { create_list :user, 5 }
  let!(:store) { create :store}
  let(:params) { { store_id: store.id } }
  let(:service) { described_class.new(**params) }

  def create_review(user, recommend, room_volume=nil, time_limit=nil, socket_supply=nil)
    create :review, {
      user: user,
      store: store,
      recommend: recommend,
      room_volume: room_volume,
      time_limit: time_limit,
      socket_supply: socket_supply
    }
  end

  before do
    create_review(users[0], 'yes', nil, 'yes', 'rare')
    create_review(users[1], 'no', 'loud', 'weekend', nil)
    create_review(users[2], 'yes', 'loud', 'weekend', nil)
    create_review(users[3], 'normal', 'loud', 'yes', 'yes')
    create_review(users[4], 'yes', nil, 'weekend', 'yes')
  end

  it 'takes required attributes to initialize' do
    described_class.new(store_id: 1)
  end

  it 'return report' do
    res = service.perform

    expect_res = {
      recommend: {
        no: 1,
        normal: 1,
        yes: 3
      },
      room_volume: {
        quiet: 0,
        normal: 0,
        loud: 3
      },
      time_limit: {
        no: 0,
        weekend: 3,
        yes: 2
      },
      socket_supply: {
        no: 0,
        rare: 1,
        yes: 2
      }
    }
    expect(res).to eq(expect_res)
  end
end
