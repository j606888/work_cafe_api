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
  

    it 'validate email & password' do
      res = service.perform

      expect(res).to eq(user)
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
