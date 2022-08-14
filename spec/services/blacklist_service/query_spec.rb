require 'rails_helper'

describe BlacklistService::Query do
  let!(:blacklists) { create_list :blacklist, 10 }
  let(:service) { described_class.new() }

  it 'takes required attributes to initialize' do
    described_class.new
  end

  it 'return all blacklist keywords' do
    res = service.perform

    expect(res.length).to eq(10)
    expect(res).to eq(blacklists)
  end
end
