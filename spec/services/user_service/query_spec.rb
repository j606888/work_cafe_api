require 'rails_helper'

describe UserService::Query do
  let!(:users) { create_list :user, 20 }
  let(:params) do
    {
      page: 1,
      per: 10
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new
  end

  it 'return users with order id DESC' do
    res = service.perform

    expect(res.length).to eq(10)
    expect(res).to eq(users.reverse[0..9])
  end

  it 'raise error if per over 100' do
    params[:per] = 101

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
