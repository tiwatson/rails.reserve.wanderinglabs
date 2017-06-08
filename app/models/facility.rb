class Facility < ApplicationRecord
  belongs_to :agency
  has_many :sites
  has_many :availability_requests

  def self.active_facilities
    Facility.joins(:availability_requests).merge(AvailabilityRequest.active)
  end

  def scraper_details
    {
      facilityId: id,
      contractCode: 'NRSO',
      parkId: details['LegacyFacilityID'].to_i.to_s,
      startDate: scrape_start.strftime('%m/%d/%Y'),
      endDate: scrape_end.strftime('%m/%d/%Y')
    }
  end

  def scrape_start
    [Time.now.to_date, availability_requests.active.map(&:date_start).sort.first].max
  end

  def scrape_end
    availability_requests.active.map(&:date_end).sort.last
  end
end
