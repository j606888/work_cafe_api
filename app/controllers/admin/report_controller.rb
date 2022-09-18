class Admin::ReportController < Admin::ApplicationController
  def dashboard
    res = ReportService::Dashboard.call

    render json: res
  end
end
