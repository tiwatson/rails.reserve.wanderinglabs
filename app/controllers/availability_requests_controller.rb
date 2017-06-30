class AvailabilityRequestsController < ApplicationController
  def index
    @availability_requests = AvailabilityRequest.all
    render json: @availability_requests
  end
end
