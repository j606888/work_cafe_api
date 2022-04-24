require 'rails_helper'

describe StoreService::QueryAll do
  describe '::new()' do
    it 'init with desired parameters' do
      described_class.new()
    end 
  end

  describe '#perform' do
    let!(:stores) { FactoryBot.create_list :store, 5 }
    # let(:params) { {} }
    let(:service) { described_class.new }

    it 'query all' do
      res = service.perform
      expect(res.count).to eq(5)
    end

    context 'when city is present' do
      let(:city) { '台南市' }

      before do
        stores[1].update!(city: city)
        stores[3].update!(city: city)
      end

      it 'query stores in Tainan' do
        res = described_class.new(city: city).perform

        expect(res[0]).to eq(stores[3])
        expect(res[1]).to eq(stores[1])
      end

      context 'when districts is present' do
        let(:district) { '中西區' } 

        before do
          stores[3].update!(district: district)
        end

        it 'query stores in distriact' do
          res = described_class.new(
            city: city,
            districts: [district] 
          ).perform

          expect(res.length).to eq(1)
          expect(res.first).to eq(stores[3])
        end
      end
    end
  end
end
