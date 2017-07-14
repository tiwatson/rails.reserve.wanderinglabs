class SitesController < ApplicationController
  def index
    facility = Facility.find(params[:facility_id])
    sites = facility.sites.lookup(params[:q])
    render json: sites
  end
end
