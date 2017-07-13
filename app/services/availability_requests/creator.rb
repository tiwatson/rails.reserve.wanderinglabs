class AvailabilityRequests::Creator
  attr_reader :params
  def initialize(params)
    Rails.logger.debug params
    @params = params
  end

  def create
    ar = AvailabilityRequest.new(merged_params)
    ar.save
    ar.reload # so we have uuid
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
    @_user ||= User.find_or_create_by(email: params[:email])
  end
end
