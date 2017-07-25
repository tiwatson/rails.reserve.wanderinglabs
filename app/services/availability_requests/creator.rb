class AvailabilityRequests::Creator
  attr_reader :params, :current_user
  def initialize(params, current_user = nil)
    Rails.logger.debug params
    @params = params
    @current_user = current_user
  end

  def create
    ar = AvailabilityRequest.new(merged_params)
    ar.date_end ||= ar.date_start
    ar.cache_site_ids
    ar.status = :active
    if ar.save
      ar.reload # so we have uuid
    else
      Rails.logger.fatal ar.errors.to_json
    end
    ar
  end

  def merged_params
    new_params = params.dup
    new_params.delete(:email)
    { facility: facility, user: user }.merge(new_params)
  end

  private

  def facility
    @_facility = Facility.find(params[:facility_id])
  end

  def user
    @_user ||= current_user || User.find_or_create_by(email: params[:email])
  end
end
