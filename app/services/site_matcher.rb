class SiteMatcher
  attr_reader :availability_request
  def initialize(availability_request)
    @availability_request = availability_request
  end

  def matching_site_ids
    return availability_request.specific_site_ids unless availability_request.specific_site_ids.empty?
    matches = availability_request.facility.sites
    matches = matches.where(water: true) if availability_request.water?
    matches = matches.where(sewer: true) if availability_request.sewer?
    matches = matches.electric(availability_request.min_electric) if availability_request.min_electric
    matches = matches.site_length(availability_request.min_length) if availability_request.min_length
    matches = matches.where(site_type: site_type) unless site_type.nil?
    matches.pluck(:id)
  end

  def site_type
    return nil if availability_request.site_type.blank?
    if availability_request.site_type == :rv_tent
      %i[rv tent]
    else
      availability_request.site_type
    end
  end
end
