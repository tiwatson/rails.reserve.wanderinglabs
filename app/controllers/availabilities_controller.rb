class AvailabilitiesController < ApplicationController
  skip_before_action :login_required, only: [:import]

  def import
    Resque.enqueue(ImportAvailabilities::Index, facility.id, params[:import], params[:hash])
    render status_code: 200
  end
end
