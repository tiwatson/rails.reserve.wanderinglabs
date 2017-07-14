class AvailabilityRequestsController < ApplicationController
  def index
    @availability_requests = AvailabilityRequest.active
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

  def update
    availability_request = AvailabilityRequest.find_by_uuid(params[:id])
    availability_request.update_attributes(status: params[:status])
    Rails.logger.debug "Errors #{availability_request.errors.to_json}"
    render json: availability_request
  end

  private

  def availability_request_params
    params.require(:availability_request).permit(:facility_id, :email, :date_start, :date_end, :stay_length, :sewer)
  end
end
