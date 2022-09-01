class User::ApplicationController < ApplicationController
  before_action :authenticate_user!

  private
  def authenticate_user!
    if current_user.nil?
      render status: 401, json: { reason: 'authenticate user failed' }
    end
  end
end
