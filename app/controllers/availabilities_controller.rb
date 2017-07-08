class AvailabilitiesController < ApplicationController
  skip_before_action :login_required, only: [:import]

  def show
  end

  def import
    Resque.enqueue(AvailabilityImports::Index, params[:facility_id], params[:import], params[:hash])
    render status_code: 200
  end
end
