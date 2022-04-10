require 'rails_helper'

describe AuthService::Decoder do
  describe '::new()' do
    it 'takes desired keys to init' do
      AuthService::Decoder.new(
        access_token: 'some_token'
      )
    end
  end

  describe '#perform' do
    let!(:user) { FactoryBot.create :user }
    let(:mock_decode) do
      [
        {
          'user_id' => user.id
        }
      ]
    end
    let(:access_token) { 'some_token' }
    let(:service) { AuthService::Decoder.new(access_token: access_token) }

    before(:each) do
      allow(JWT).to receive(:decode).and_return(mock_decode)
    end

    it 'decode access_token' do
      res = service.perform

      expect(JWT).to have_received(:decode).with(
        access_token,
        AuthService::Decoder::HMAC_SECRET,
        true,
        { algorithm: 'HS256' }
      )
      expect(res).to eq(user)
    end

    it 'raise PerformFailed when receive JWT error' do
      allow(JWT).to receive(:decode)
        .and_raise(JWT::DecodeError)

      expect { service.perform }.to raise_error(Service::PerformFailed)
    end
  end
end
