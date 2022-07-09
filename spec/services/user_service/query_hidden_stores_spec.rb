require 'rails_helper'

describe UserService::QueryHiddenStores do
  describe '::new()' do
    it 'init with desired parameters' do
      described_class.new(
        user_id: 1
      )
    end 
  end

  describe '#perform' do
    let!(:user) { FactoryBot.create :user }
    let!(:stores) { FactoryBot.create_list :store, 5 }
    let!(:hiddens) do
      stores.first(3).map do |store|
        FactoryBot.create :hidden, {
          user: user,
          store: store
        }
      end
    end
    let(:service) { described_class.new(user_id: user.id) }

    it 'should query hidden stores' do
      res = service.perform
      expect(res.count).to eq(3)
      expect(res.pluck(:id)).to eq(hiddens.first(3).pluck(:store_id))
    end
  end
end
