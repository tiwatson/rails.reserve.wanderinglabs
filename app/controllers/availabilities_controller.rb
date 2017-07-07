class AvailabilitiesController < ApplicationController
  skip_before_action :login_required, only: [:import]

  def import
    facility = Facility.find(params[:facility_id])
    facility.last_import_hash = params[:hash]
    facility.last_import = Time.now
    facility.save
    if facility.previous_changes.keys.include?('last_import_hash')
      Resque.enqueue(ImportAvailabilities::RecreationGov, facility.id, params[:import])
    end
    render status_code: 200
  end
end
