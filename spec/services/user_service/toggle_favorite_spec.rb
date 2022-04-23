require 'rails_helper'

describe UserService::ToggleFavorite do
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
    let(:service) do
      described_class.new(
        user_id: user.id,
        store_id: store.id
      )
    end
    
    it 'creaet a new favorite record' do
      service.perform

      favorite = Favorite.last
      expect(favorite.user).to eq(user)
      expect(favorite.store).to eq(store)
    end

    context 'when favorite record exist' do
      let!(:favorite) do
        FactoryBot.create :favorite, {
          user: user,
          store: store
        }
      end

      it 'delete the record' do
        expect { service.perform }.to change { Favorite.count }.from(1).to(0)
      end
    end
  end
end
