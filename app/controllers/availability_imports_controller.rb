class AvailabilityImportsController < ApplicationController
  def index
    availability_imports = AvailabilityImport.order('id desc').limit(100)
    render json: availability_imports
  end
end
