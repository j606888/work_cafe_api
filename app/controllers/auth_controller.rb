class AuthController < ApplicationController
  def signup
    user = AuthService::Signup.new(
      name: params.require(:name),
      email: params.require(:email),
      password: params.require(:password)
    ).perform

    token = AuthService::Encoder.new(
      user_id: user.id 
    ).perform

    render json: {
      access_token: token[:access_token],
      refresh_token: token[:refresh_token]
    }
  end

  def login
    user = AuthService::Login.new(
      email: params.require(:email),
      password: params.require(:password)
    ).perform

    token = AuthService::Encoder.new(
      user_id: user.id
    ).perform

    render json: {
      access_token: token[:access_token],
      refresh_token: token[:refresh_token]
    }
  rescue AuthService::Login::EmailOrPasswordInvalid => e
    render status: 400, json: { reason: e.message }
  end

  def refresh
    token = AuthService::Refresh.new(
      token: params.require(:refresh_token)
    ).perform

    render json: {
      access_token: token[:access_token],
      refresh_token: token[:refresh_token]
    }
  end
end
