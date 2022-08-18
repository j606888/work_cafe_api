class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from Service::PerformFailed, with: :handle_perform_fail
  rescue_from ActionController::ParameterMissing, with: :handle_param_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from AASM::InvalidTransition, with: :handle_aasm_invalid
  rescue_from JWT::ExpiredSignature, with: :handle_jwt_expired

  private
  def handle_perform_fail(e)
    render status: 409, json: { reason: e.message }
  end

  def handle_param_missing(e)
    render status: 409, json: { reason: e.message }
  end

  def handle_record_invalid(e)
    render status: 409, json: { reason: e.message }
  end

  def handle_record_not_found(e)
    render status: 404, json: { reason: e.message }
  end

  def handle_aasm_invalid(e)
    render status: 409, json: { reason: e.message }
  end

  def handle_jwt_expired(e)
    render status: 403, json: { reason: e.message }
  end
end
