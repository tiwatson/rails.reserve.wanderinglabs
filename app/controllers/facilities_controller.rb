class FacilitiesController < ApplicationController
  skip_before_action :login_required, only: [:index]

  def index
    @facilities = Facility.lookup(params[:q])
    render json: @facilities
  end
end
