class AuthService::GoogleSignIn < Service
  CLIENT_ID = ENV['GOOGLE_SIGN_IN_API_KEY']
  def initialize(token:)
    @token = token
  end

  def perform
    jwt_object = decode_token!(@token)
    aud = jwt_object.dig(0, 'aud')
    payload = check_payload!(@token, aud)

    third_party_login = ThirdPartyLogin.find_by(email: payload[:email])
    return third_party_login.user if third_party_login.present?

    user = find_or_create_user!(payload)
    create_third_party_login!(user)

    user
  end

  private

  def decode_token!(token)
    JWT.decode(@token, nil, false)
  rescue JWT::DecodeError => e
    raise Service::PerformFailed, "jwt with token `#{token}` decode failed"
  end

  def check_payload!(token, aud)
    validator = GoogleIDToken::Validator.new
    payload = validator.check(token, aud, CLIENT_ID)

    {
      email: payload['email'],
      name: payload['name'],
      picture: payload['picture']
    }
  rescue GoogleIDToken::ValidationError => e
    raise Service::PerformFailed, "GoogleSign Failed"
  end

  def find_or_create_user!(payload)
    user = User.find_by(email: payload[:email])
    return user if user.present?

    User.create!(
      email: payload[:email],
      name: payload[:name],
      password: SecureRandom.hex
    )
  end
  
  def create_third_party_login!(user)
    ThirdPartyLogin.create!(
      user: user,
      email: user.email,
      provider: 'google'
    )
  end
end
