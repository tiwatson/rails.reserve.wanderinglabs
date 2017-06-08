class Site < ApplicationRecord
  extend Enumerize

  belongs_to :facility

  enumerize :site_type, in: %i[group tent_walk_in tent other rv], predicates: { prefix: true }

  scope :electric, (->(lngth) { where('electric >= ?', lngth) })
  scope :site_length, (->(lngth) { where('length >= ?', lngth) })

  def reserve_link(date, length)
    arvdate = date.strftime('%m/%d/%Y')
    "https://www.recreation.gov/camping/Watchman_Campground/r/campsiteDetails.do?siteId=#{ext_site_id}&contractCode=NRSO&parkId=#{facility.details['LegacyFacilityID'].to_i}&offset=0&arvdate=#{arvdate}&lengthOfStay=#{length}"
  end
end
