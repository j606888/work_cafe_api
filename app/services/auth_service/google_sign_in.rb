class AuthService::GoogleSignIn < Service
  CLIENT_ID = ENV['GOOGLE_SIGN_IN_API_KEY']

  def initialize(credential:, debug_mode: false)
    @credential = credential
    @debug_mode = debug_mode
  end

  def perform
    jwt_object = decode_token!(@credential)
    payload = check_payload!(@credential, jwt_object, @debug_mode)

    third_party_login = ThirdPartyLogin.find_by(identity: payload[:identity])
    return third_party_login.user if third_party_login.present?

    user = find_or_create_user!(payload)
    create_third_party_login!(user, payload[:identity])

    user
  end

  private

  def decode_token!(credential)
    JWT.decode(@credential, nil, false)
  rescue JWT::DecodeError => e
    raise Service::PerformFailed, "jwt with token `#{credential}` decode failed"
  end

  def check_payload!(credential, jwt_object, debug_mode)
    if @debug_mode
      payload = jwt_object[0]
    else
      aud = jwt_object.dig(0, 'aud')
      validator = GoogleIDToken::Validator.new(expiry: 5)
      payload = validator.check(credential, aud, CLIENT_ID)
    end

    {
      email: payload['email'],
      name: payload['name'],
      picture: payload['picture'],
      identity: payload['sub']
    }
  rescue GoogleIDToken::ValidationError => e
    raise Service::PerformFailed, "GoogleSign Failed"
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
