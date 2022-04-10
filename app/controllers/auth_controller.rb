class AuthController < ApplicationController
  def signup
    res = AuthService::Signup.new(
      name: params.require(:name),
      email: params.require(:email),
      password: params.require(:password)
    ).perform

    head :ok
  end
end
