class ImportAvailabilities
  attr_reader :facility_id, :scrape, :body
  def initialize(facility_id, scrape, body)
    @facility_id = facility_id
    @scrape = scrape
    @body = JSON.parse(body)
  end

  def perform
    body.each do |avail_date, ext_sites|
      puts "avail_date - #{avail_date}"
      avail_date_date = Date.strptime(avail_date, '%m/%d/%Y')
      puts "avail_date_date - #{avail_date_date.month}"

      sites = Site.where(facility_id: facility_id).where(ext_site_id: ext_sites)
      Availability.bulk_insert do |avail|
        sites.all.each do |site|
          avail.add(facility_id: facility_id, site_id: site.id, scrape: scrape, avail_date: avail_date_date)
        end
      end
    end
  end
end

=begin
f = Facility.find 10612
s='http://availabilities-dev.s3.amazonaws.com/NRSO/70923/17_06_02_20_43.json'
require 'httparty'
b=HTTParty.get(s)
body = b.body
i=ImportAvailabilities.new(f.id, 'test', body)
i.perform

=end
