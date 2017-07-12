class ReserveUrl
  attr_reader :availability_match, :site, :availability_request

  def initialize(availability_match)
    @availability_match = availability_match
    @site = availability_match.site
    @availability_request = availability_match.availability_request
  end

  def url
    arvdate = availability_match.avail_date.strftime('%m/%d/%Y')
    "https://www.recreation.gov/camping/Watchman_Campground/r/campsiteDetails.do?siteId=#{site.ext_site_id}&contractCode=NRSO&parkId=#{site.facility.details['LegacyFacilityID'].to_i}&offset=0&arvdate=#{arvdate}&lengthOfStay=#{availability_request.stay_length}"
  end
end
