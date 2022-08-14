require 'rails_helper'

describe BlacklistService::Delete do
  let!(:blacklist) { create :blacklist }
  let(:params) do
    {
      id: blacklist.id
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      id: 1
    )
  end

  it 'delete  blacklist' do
    expect { service.perform }.to change { Blacklist.count }.by(-1)
  end

  it 'raise error if blacklist not found' do
    blacklist.delete

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
