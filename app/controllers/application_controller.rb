class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from Service::PerformFailed, with: :handle_perform_fail
  rescue_from ActionController::ParameterMissing, with: :handle_param_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from AASM::InvalidTransition, with: :handle_aasm_invalid

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

  def handle_aasm_invalid(e)
    render status: 409, json: { reason: e.message }
  end
end
