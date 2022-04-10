require 'rails_helper'

describe AuthService::Encoder do
  describe '::new()' do
    it 'takes desired keys to init' do
      AuthService::Encoder.new(
        user_id: 123
      )
    end
  end

  describe '#perform' do
    let!(:user) { FactoryBot.create :user }
    let(:service) do
      AuthService::Encoder.new(
        user_id: user
      )
    end
    let(:access_token) { 'access_token' }

    before :each do
      allow(JWT).to receive(:encode).and_return(access_token)
    end

    it 'should return access_token & refresh_token' do
      res = service.perform

      expect(JWT).to have_received(:encode)
      expect(res[:access_token]).to eq(access_token)
      expect(res[:refresh_token]).to eq(RefreshToken.first.token)
    end
  end
end
