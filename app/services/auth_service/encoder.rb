class AuthService::Encoder < Service
  HMAC_SECRET = ENV['JWT_SECRET_KEY']
  DEFAULT_EXPIRED_TIME = 1.day

  def initialize user_id:
    @user_id = user_id
  end

  def perform
    user = query_user!(@user_id)
    access_token = issue_access_token(user)
    refresh_token = issue_refresh_token(user)

    {
      access_token: access_token,
      refresh_token: refresh_token
    }
  end

  private
  def query_user! user_id
    user = User.find_by(id: user_id)
    if user.nil?
      raise Service::PerformFailed, "User with id `#{user}` not found"
    end

    user
  end

  def issue_access_token user
    payload = {
      name: user.name,
      email: user.email,
      user_id: user.id,
      role: user.role,
      avatar_url: user.avatar_url,
      exp: expire_at
    }
    JWT.encode(payload, HMAC_SECRET, 'HS256')
  end

  def issue_refresh_token user
    refresh_token = user.refresh_tokens.create!
    refresh_token.token
  end

  def expire_at
    expire_time = DEFAULT_EXPIRED_TIME

    (Time.now + expire_time).to_i
  end
end
