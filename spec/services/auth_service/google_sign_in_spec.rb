require 'rails_helper'

describe AuthService::GoogleSignIn do
  let(:service) { described_class.new(token: 'some-token') }
  let(:jwt_object) do
    [ { 'aud' => 'some-aud' } ]
  end
  let(:payload) do
    {
      'email' => 'test@test.com',
      'name' => 'Test User',
      'picture' => "https://lh3.googleusercontent.com/a/AItbvmlo4FhjkJ3nx0WgHJIfDeJqb7wD_yJI6Bzuco-N=s96-c"
    }
  end
  let(:validator) { double(check: payload)}

  before do
    allow(JWT).to receive(:decode).and_return(jwt_object)
    allow(GoogleIDToken::Validator).to receive(:new).and_return(validator)
  end

  it "init service with required attr" do
    described_class.new(token: 'some-token')
  end

  it "create and return user" do
    res = service.perform

    expect(res).to eq(User.last)
    expect(res.email).to eq('test@test.com')
    expect(res.name).to eq('Test User')
  end

  it "validate google_id_token" do
    service.perform

    expect(GoogleIDToken::Validator).to have_received(:new)
    expect(validator).to have_received(:check).with(
      'some-token',
      'some-aud',
      described_class::CLIENT_ID
    )
  end

  it "create user with SecureRandom" do
    password = 'some-random-password'
    allow(SecureRandom).to receive(:hex).and_return(password)

    user = service.perform
    expect(user.password).to eq(password)
  end

  it "create third_party_login" do
    user = service.perform

    third_party_login = ThirdPartyLogin.last
    expect(third_party_login.email).to eq('test@test.com')
    expect(third_party_login.provider).to eq('google')
    expect(third_party_login.user).to eq(user)
  end

  context "when user already exist" do
    let!(:user) { create :user, email: payload['email'] }

    it "only create third_party_login" do
      res = service.perform

      expect(User.count).to eq(1)
      expect(res).to eq(user)
      expect(user.third_party_logins.count).to eq(1)
    end
  end

  context "when user & third_party_login exist" do
    let!(:user) { create :user, email: payload['email'] }
    let!(:third_party_login) { create :third_party_login, user: user, email: user.email }

    it "return user without create anything" do
      res = service.perform

      expect(res).to eq(user)
      expect(User.count).to eq(1)
      expect(ThirdPartyLogin.count).to eq(1)
    end
  end

  it "raise Service::PerformFailed if JWT decode failed" do
    allow(JWT).to receive(:decode).and_raise(JWT::DecodeError)

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end

  it "raise Service::PerformFailed if JWT decode failed" do
    allow(validator).to receive(:check).and_raise(GoogleIDToken::ValidationError)

    expect { service.perform }.to raise_error(Service::PerformFailed)
  end


end
