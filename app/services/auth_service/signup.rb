class AuthService::Signup < Service
  def initialize(name:, email:, password:)
    @name = name
    @email = email
    @password = password
  end

  def perform
    validate_email!(@email)

    User.create!(
      name: @name,
      email: @email,
      password: @password
    )
  end

  private
  def validate_email!(email)
    exist = User.find_by(email: email)
    if exist
      raise Service::PerformFailed, "Email was taken, please try another"
    end
  end
end
