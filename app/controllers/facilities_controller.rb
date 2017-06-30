class FacilitiesController < ApplicationController
  def index
    @facilities = Facility.lookup(params[:q])
    render json: @facilities
  end
end
