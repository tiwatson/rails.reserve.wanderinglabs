class AvailabilityMatchesController < ApplicationController
  skip_before_action :login_required, only: [:index]

  def index
    availability_request = AvailabilityRequest.find_by_uuid(params[:availability_request_id])
    @availability_matches = availability_request.availability_matches
    render json: @availability_matches
  end
end
