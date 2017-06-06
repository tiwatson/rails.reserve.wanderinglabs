class ImportAvailabilities
  attr_reader :facility_id, :scrape, :body
  def initialize(facility_id, scrape, body)
    @facility_id = facility_id
    @scrape = scrape
    @body = JSON.parse(body)
  end

  def perform
    body.each do |avail_date, ext_sites|
      sites = Site.where(facility_id: facility_id, ext_site_ids: ext_sites)
      sites.all.each do |site|
        Availability.create(facility_id: facility_id, site_id: site.id, scrape: scrape, avail_date: avail_date)
      end
    end
  end
end
