class AuthService::Refresh < Service
  def initialize(token:)
    @token = token
  end

  def perform
    refresh_token = query_refresh_token!(@token)

    AuthService::Encoder.new(
      user_id: refresh_token.user_id
    ).perform
  end

  private
  def query_refresh_token!(token)
    refresh_token = RefreshToken.find_by(token: token)
    if refresh_token.nil?
      raise Service::PerformFailed, "RefreshToken with token `#{token}` not found"
    end

    refresh_token
  end
end
