require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe 'POST :google_sign_in' do
    let(:user) { create :user }
    let(:credential) { 'some-jwt' }
    let(:token) do
      {
        access_token: 'access-token',
        refresh_token: 'refresh-token'
      }
    end

    before do
      allow(AuthService::GoogleSignIn).to receive(:call).and_return(user)
      allow(AuthService::Encoder).to receive(:call).and_return(token)
    end

    it "pass params to services" do
      post :google_sign_in, params: { credential: credential }

      expect(response.status).to eq(200)
      expect(AuthService::GoogleSignIn).to have_received(:call)
        .with(credential: credential)
      expect(AuthService::Encoder).to have_received(:call)
        .with(user_id: user.id)
    end
  end
end
