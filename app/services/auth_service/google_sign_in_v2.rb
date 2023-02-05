class AuthService::GoogleSignInV2 < Service
  API_PATH = "https://www.googleapis.com/oauth2/v1/userinfo"
  CLIENT_ID = ENV['GOOGLE_SIGN_IN_API_KEY']

  def initialize(access_token:)
    @access_token = access_token
  end

  def perform
    headers = { 'Authorization' => "Bearer #{@access_token}" }
    response = HTTParty.get(API_PATH, { headers: headers })

    if response['error'].present?
      raise Service::PerformFailed, "Google login failed"
    end

    payload = parse_response(response)

    third_party_login = ThirdPartyLogin.find_by(identity: payload[:id])
    return third_party_login.user if third_party_login.present?

    user = find_or_create_user!(payload)
    create_third_party_login!(user, payload[:id])

    user
  end

  private

  def parse_response(response)
    {
      id: response['id'],
      email: response['email'],
      name: response['name'],
      picture: response['picture']
    }
  end

  def find_or_create_user!(payload)
    user = User.find_by(email: payload[:email])
    return user if user.present?

    user = User.create!(
      email: payload[:email],
      name: payload[:name],
      avatar_url: payload[:picture],
      password: SecureRandom.hex
    )
    user
  end

  def create_third_party_login!(user, identity)
    ThirdPartyLogin.create!(
      user: user,
      email: user.email,
      provider: 'google',
      identity: identity
    )
  end
end
