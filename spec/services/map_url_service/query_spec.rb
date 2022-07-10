require 'rails_helper'

describe MapUrlService::Query do
  let!(:map_urls) { create_list :map_url, 3, decision: 'waiting' }
  let(:params) do
    {}
  end
  let(:service) { described_class.new(**params) }

  it "init with required attr" do
    described_class.new
  end

  it "query all map_urls" do
    res = service.perform

    expect(res.count).to eq(3)
    expect(res.map(&:id)).to eq(map_urls.reverse.map(&:id))
  end

  context "when user_id provide" do
    let!(:user) { create :user }

    before do
      map_urls[0].update!(user: user)
      params[:user_id] = user.id
    end

    it "query user's map_url" do
      res = service.perform

      expect(res.count).to eq(1)
      expect(res.first.id).to eq(map_urls[0].id)
    end
  end

  context "when decision provide" do
    before do
      map_urls[1].update!(decision: 'parse_failed')
      params[:decision] = 'parse_failed'
    end

    it "query map_url with specific decision" do
      res = service.perform

      expect(res.count).to eq(1)
      expect(res.first.id).to eq(map_urls[1].id)
    end
  end

  it "raise error if over max per" do
    params[:per] = 101

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end
end
