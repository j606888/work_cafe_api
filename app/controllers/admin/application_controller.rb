class Admin::ApplicationController < ApplicationController
  before_action :authenticate_admin!

  private
  def authenticate_admin!
    if current_admin.nil?
      render status: 401, json: { reason: 'authenticate user failed' }
    end
  end

  def current_admin
    return @current_admin if @current_admin

    pattern = /^Bearer /
    header  = request.headers['Authorization']
    access_token = header.gsub(pattern, '') if header && header.match(pattern)
    return if access_token.nil?

    @current_admin = AuthService::Decoder.new(
      access_token: access_token
    ).perform

    if @current_admin.role != 'admin'
      return render status: 401, json: { reason: 'User is not a admin' }
    end

    @current_admin
  end
end
