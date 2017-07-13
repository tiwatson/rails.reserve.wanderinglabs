class AvailabilityRequestsController < ApplicationController
  def index
    @availability_requests = AvailabilityRequest.all
    render json: @availability_requests
  end

  def show
    @availability_request = AvailabilityRequest.find_by_uuid(params[:id])
    render json: @availability_request
  end

  def create
    availability_request = AvailabilityRequests::Creator.new(availability_request_params).create
    render json: availability_request
  end

  private

  def availability_request_params
    params.require(:availability_request).permit(:facility_id, :email, :date_start, :date_end, :stay_length, :sewer)
  end
end
