require 'rails_helper'

describe MapCrawlerService::CreateWorker do
  let(:params) do
    {
      user_id: 123,
      lat: 22.9994438,
      lng: 120.2048099,
      radius: 1000
    }
  end
  let(:args) do
    [params[:user_id], params[:lat], params[:lng], params[:radius]]
  end

  def run_worker
    described_class.new.perform(*args)
  end

  before do
    allow(MapCrawlerService::Create).to receive(:call)
  end

  it "pass args to service" do
    run_worker

    expect(MapCrawlerService::Create).to have_received(:call)
  end
end
