require 'rails_helper'

describe AdminService::DenyMapUrl do
  describe '::new()' do
    it 'init with desired parameters' do
      AdminService::DenyMapUrl.new(
        map_url_id: 1
      )
    end 
  end

  describe '#perform' do
    let!(:map_url) { FactoryBot.create :map_url }
    let(:service) { described_class.new(map_url_id: map_url.id) }

    it 'should update aasm_state as `deny`' do
      expect { service.perform }.to change {
        map_url.reload.aasm_state
      }.from('created').to('deny')
    end

    it 'should raise error if state invalid' do
      map_url.update!(aasm_state: 'deny')

      expect { service.perform }.to raise_error(AASM::InvalidTransition)
    end
  end
end
