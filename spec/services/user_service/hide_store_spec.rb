require 'rails_helper'

describe UserService::HideStore do
  describe '::new()' do
    it 'init with desired parameters' do
      described_class.new(
        user_id: 1,
        store_id: 1
      )
    end 
  end

  describe '#perform' do
    let!(:user) { FactoryBot.create :user }
    let!(:store) { FactoryBot.create :store }
    let(:service) { described_class.new(user_id: user.id, store_id: store.id) }
    
    it 'hide store' do
      service.perform

      hidden = Hidden.last
      expect(hidden.user).to eq(user)
      expect(hidden.store).to eq(store)
    end

    it 'should raise if Hidden already exist' do
      service.perform

      expect { service.perform }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
