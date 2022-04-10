class User::ApplicationController < ApplicationController
  before_action :authenticate_user!

  private
  def authenticate_user!
    if current_user.nil?
      render status: 401, json: { reason: 'authenticate user failed' }
    end
  end

  def current_user
    return @current_user if @current_user

    pattern = /^Bearer /
    header  = request.headers['Authorization']
    access_token = header.gsub(pattern, '') if header && header.match(pattern)
    return if access_token.nil?

    @current_user = AuthService::Decoder.new(
      access_token: access_token
    ).perform
  end
end
