class FacilitiesController < ApplicationController
  def index
    @facilities = Facility.lookup(params[:q])
    render json: @facilities
  end

  def grouped_availabilities
    @facility = Facility.find(params[:id])
    avails = Facilities::Stats.new(@facility, 1).search

    site_ids = avails.map { |h| h[:site_id] }.uniq
    sites = Site.where(id: site_ids).all
    avails_mapped = avails.map do |h|

      site = sites.select { |s| h[:site_id] == s.id }.first
      h.merge(site: SiteSerializer.new(site) )

    end

    render json: avails_mapped
  end
end
