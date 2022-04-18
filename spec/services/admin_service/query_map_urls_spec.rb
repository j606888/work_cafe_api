require 'rails_helper'

describe AdminService::QueryMapUrls do
  describe '::new()' do
    it 'init with desired parameters' do
      AdminService::QueryMapUrls.new(
      )
    end 
  end

  describe '#perform' do
    let!(:map_urls) { FactoryBot.create_list :map_url, 10 }
    let(:service) { described_class.new }

    it 'should return all map_urls' do
      res = service.perform

      expect(res.count).to eq(10)
      expect(res[0]).to eq(map_urls.last)
    end

    context 'when status is provide' do
      before(:each) do
        map_urls[0].update(aasm_state: 'accept')
        map_urls[2].update(aasm_state: 'accept')
        map_urls[4].update(aasm_state: 'accept')
      end

      it 'should return the state list' do
        res = described_class.new(
          status: 'accept'
        ).perform

        expect(res.count).to eq(3)
        expect(res[0]).to eq(map_urls[4])
        expect(res[1]).to eq(map_urls[2])
        expect(res[2]).to eq(map_urls[0])
      end

      it 'should raise error if state invalid' do
        expect do
          described_class.new(
            status: 'cool'
          ).perform
        end.to raise_error(Service::PerformFailed)
      end
    end

  end
end
