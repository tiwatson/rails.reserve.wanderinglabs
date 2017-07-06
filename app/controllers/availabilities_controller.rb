class AvailabilitiesController < ApplicationController
  def import
    facility = Facility.find(params[:facility_id])
    facility.last_import_hash = params[:hash]
    facility.last_import = Time.now
    facility.save
    if facility.previous_changes.keys.include?('last_import_hash')
      Resque.enqueue(Import, facility.id, params)
    end
    render status_code: 200
  end
end
