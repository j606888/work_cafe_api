require 'rails_helper'

describe StoreService::HideAllUnqualified do
  let!(:stores) { create_list :store, 5, hidden: false }
  let(:service) { described_class.new }

  it 'takes required attributes to initialize' do
    described_class.new()
  end

  it 'hide blacklist stores' do
    create :blacklist, keyword: '清新'
    stores[0].update!(name: '清新台南民族店')
    stores[3].update!(name: '台中清新總店')

    service.perform

    expect(Store.where(hidden: true).pluck(:id)).to eq([stores[0], stores[3]].map(&:id))
  end

  it 'hide zero rating stores' do
    stores[1].update!(user_ratings_total: nil)
    stores[4].update!(user_ratings_total: nil)

    service.perform

    expect(Store.where(hidden: true).pluck(:id)).to eq([stores[1], stores[4]].map(&:id))
  end

  it 'hide bad rating stores' do
    stores[0].update!(rating: 4.5)
    stores[1].update!(rating: 4.4)
    stores[2].update!(rating: 1.5)
    stores[3].update!(rating: 2.2)
    stores[4].update!(rating: 3.8)

    service.perform

    expect(Store.where(hidden: true).pluck(:id)).to eq([stores[2], stores[3]].map(&:id))
  end

  it 'hide permanently closed stores' do
    stores[1].update!(permanently_closed: true)
    stores[2].update!(permanently_closed: true)

    service.perform

    expect(Store.where(hidden: true).pluck(:id)).to eq([stores[1], stores[2]].map(&:id))
  end

end
