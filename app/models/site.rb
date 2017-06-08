class Site < ApplicationRecord
  belongs_to :facility

  def reserve_link(date, length)
    arvdate = date.strftime('%m/%d/%Y')
    "https://www.recreation.gov/camping/Watchman_Campground/r/campsiteDetails.do?siteId=#{ext_site_id}&contractCode=NRSO&parkId=#{facility.details['LegacyFacilityID'].to_i}&offset=0&arvdate=#{arvdate}&lengthOfStay=#{length}"
  end
end
