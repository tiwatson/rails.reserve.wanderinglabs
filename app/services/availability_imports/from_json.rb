class AvailabilityImports::FromJson
  attr_reader :import

  def initialize(import)
    @import = import
  end

  def perform
    # TODO: Prefetch exit_side_id to site.id lookup
    body['results'].each do |avail_date, ext_sites|
      puts "avail_date - #{avail_date}"
      avail_date_date = Date.strptime(avail_date, '%m/%d/%Y')
      puts "avail_date_date - #{avail_date_date.month}"

      sites = Site.where(facility_id: import.facility_id).where(ext_site_id: ext_sites)
      Availability.bulk_insert do |avail|
        sites.all.each do |site|
          avail.add(availability_import_id: import.id, site_id: site.id, avail_date: avail_date_date)
        end
      end
    end
    # TODO: import differences
    # select site_id, avail_date from availabilities where import = '17_06_08_17_22'
    # except
    # select site_id, avail_date from availabilities where import = 'test'
    # AND
    # select site_id, avail_date from availabilities where import = 'test'
    # except
    # select site_id, avail_date from availabilities where import = '17_06_08_17_22'
  end

  def url
    "http://availabilities-dev.s3.amazonaws.com/#{import.facility_id}/#{import.run_id}.json"
  end

  def body
    @_body ||= JSON.parse(HTTParty.get(url).body)
  end
end
