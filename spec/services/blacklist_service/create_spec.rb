require 'rails_helper'

describe BlacklistService::Create do
  let(:params) do
    {
      keyword: 'Red Sun'
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      keyword: 'some-keyword'
    )
  end

  it 'create a new blacklist' do
    res = service.perform

    expect(Blacklist.count).to eq(1)
    expect(res.keyword).to eq('Red Sun')
  end
end
