require 'rails_helper'

describe AuthService::Signup do
  describe '::new()' do
    it 'init with desired parameters' do
      AuthService::Signup.new(
        name: 'james',
        email: 'test@test.com',
        password: 'testtest'
      )
    end 
  end

  describe '#perform' do
    let(:name) { "James" }
    let(:email) { "test@test.com" }
    let(:password) { "password" }
    let(:params) do
      {
        name: name,
        email: email,
        password: password
      }
    end
    let(:service) do
      described_class.new(**params)
    end

    it 'should signup a new user' do
      user = service.perform

      expect(user.name).to eq(name)
      expect(user.email).to eq(email)
      expect(user.password).to eq(password)
    end

    it 'should have minumum password length 6' do
      params[:password] = '12345'
      expect { service.perform }.to raise_error(ActiveRecord::RecordInvalid)
    end

    context 'when email was taken' do
      before(:each) do
        FactoryBot.create :user, { email: email }
      end

      it 'should raise error' do
        expect { service.perform }.to raise_error(Service::PerformFailed)
      end
    end
  end
end
