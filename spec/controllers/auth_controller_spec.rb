require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe 'POST :google_sign_in' do
    let(:user) { create :user }
    let(:access_token) { 'some-token' }
    let(:token) do
      {
        access_token: 'access-token',
        refresh_token: 'refresh-token'
      }
    end

    before do
      allow(AuthService::GoogleSignInV2).to receive(:call).and_return(user)
      allow(AuthService::Encoder).to receive(:call).and_return(token)
    end

    it "pass params to services" do
      post :google_sign_in, params: { access_token: access_token }

      expect(response.status).to eq(200)
      expect(AuthService::GoogleSignInV2).to have_received(:call)
        .with(access_token: access_token)
      expect(AuthService::Encoder).to have_received(:call)
        .with(user_id: user.id)
    end
  end
end
