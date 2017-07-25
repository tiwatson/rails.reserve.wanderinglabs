class Facility < ApplicationRecord
  extend Enumerize

  belongs_to :agency
  has_many :sites
  has_many :availability_requests
  has_many :availability_imports

  scope :lookup, (->(start) { where('name ILIKE ?', "#{start}%").order('name ASC').limit(15) })

  enumerize :status, in: %i[active removed requires_attention], predicates: { prefix: true }

  def self.active_facilities
    Facility.left_outer_joins(:availability_requests).merge(AvailabilityRequest.active).group('facilities.id')
  end

  def scraper_details
    {
      facilityId: id,
      contractCode: contract_code,
      parkId: park_id,
      startDate: scrape_start.strftime('%m/%d/%Y'),
      endDate: scrape_end.strftime('%m/%d/%Y'),
      hash: last_import_hash,
    }
  end

  def scrape_start
    [Time.now.to_date, availability_requests.active.map(&:date_start).sort.first].max
  end

  def scrape_end
    [booking_end, availability_requests.active.map(&:date_end).sort.last].min
  end

  def booking_end
    Date.today + (booking_window || 365)
  end

  def cache_sites_count
    update_attribute(:sites_count, sites.count)
  end
end
