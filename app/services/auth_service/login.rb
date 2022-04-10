class AuthService::Login < Service
  class EmailOrPasswordInvalid < StandardError; end

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def perform
    user = query_user_by_email!(@email)
    throw_error unless user.valid_password?(@password)

    user
  end

  private
  def query_user_by_email!(email)
    user = User.find_by(email: email)
    throw_error if user.nil?

    user
  end

  def throw_error
    raise EmailOrPasswordInvalid.new, "Email or Password Invalid"
  end
end
