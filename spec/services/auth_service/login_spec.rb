require 'rails_helper'

describe AuthService::Login do
  describe '::new()' do
    it 'takes desired keys to init' do
      AuthService::Login.new(
        email: 'someemail@gmail.com',
        password: 'password'
      )
    end
  end

  describe '#perform' do
    let(:password) { 'my_password' }
    let!(:user) { FactoryBot.create(:user, password: password) }
    let(:params) do
      {
        email: user.email,
        password: password
      }
    end
    let(:service) { AuthService::Login.new(**params) }
    let(:encoder_data) do
      {
        access_token: 'access_token',
        refresh_token: 'refresh_token'
      }
    end
    let(:encoder_service) { double(perform: encoder_data) }

    before(:each) do
      allow(AuthService::Encoder).to receive(:new).and_return(encoder_service)
    end

    it 'validate email & password' do
      res = service.perform

      expect(AuthService::Encoder).to have_received(:new)
        .with(user_id: user.id)
      expect(res[:access_token]).to eq(encoder_data[:access_token])
      expect(res[:refresh_token]).to eq(encoder_data[:refresh_token])
    end

    it 'raise error if user not found' do
      user.delete

      expect { service.perform }.to raise_error(
        AuthService::Login::EmailOrPasswordInvalid,
        "Email or Password Invalid"
      )
    end

    it 'raise error if password wrong' do
      params[:password] = 'wrong_password'

      expect { service.perform }.to raise_error(
        AuthService::Login::EmailOrPasswordInvalid,
        "Email or Password Invalid"
      )
    end
  end
end
