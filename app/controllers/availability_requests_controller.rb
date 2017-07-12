class AvailabilityRequestsController < ApplicationController
  def index
    @availability_requests = AvailabilityRequest.all
    render json: @availability_requests
  end

  def show
    @availability_request = AvailabilityRequest.find_by_uuid(params[:id])
    render json: @availability_request
  end
end
