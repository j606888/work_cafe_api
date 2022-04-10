class AuthService::Decoder < Service
  HMAC_SECRET = ENV['JWT_SECRET_KEY']

  def initialize(access_token:)
    @access_token = access_token
  end

  def perform
    payload = JWT.decode(
      @access_token,
      HMAC_SECRET,
      true,
      { algorithm: 'HS256' }
    )[0]

    query_user!(payload['user_id'])
  rescue JWT::DecodeError => e
    raise Service::PerformFailed, e
  end

  private
  def query_user! user_id
    user = User.find_by(id: user_id)
    if user.nil?
      raise Service::PerformFailed, "User not found"
    end

    user
  end
end
