class AvailabilityRequestsController < ApplicationController
  skip_before_action :login_required, only: [:index]

  def index
    @availability_requests = AvailabilityRequest.all
    render json: @availability_requests
  end
end
