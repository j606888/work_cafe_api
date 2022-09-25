require 'rails_helper'

describe NewStoreRequestService::Create do
  let!(:user) { create :user }

  let(:params) do
    {
      user_id: user.id,
      content: "A name for google map"
    }
  end
  let(:service) { described_class.new(**params) }

  it 'takes required attributes to initialize' do
    described_class.new(
      user_id: 1,
      content: 'xxx'
    )
  end

  it "create a new_store_request" do
    res = service.perform
    expect(res).to eq(NewStoreRequest.last)
    expect(res.user).to eq(user)
    expect(res.content).to eq(params[:content])
  end

  it "raise error if user not exist" do
    user.delete

    expect { service.perform }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
