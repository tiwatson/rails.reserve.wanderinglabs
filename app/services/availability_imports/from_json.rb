class AvailabilityImports::FromJson
  attr_reader :import

  def initialize(import)
    @import = import
  end

  def perform
    update_dates
    # TODO: Prefetch exit_side_id to site.id lookup
    body['results'].each do |avail_date, ext_sites|
      avail_date_date = Date.strptime(avail_date, '%m/%d/%Y')

      sites = Site.where(facility_id: import.facility_id).where(ext_site_id: ext_sites)
      Availability.bulk_insert do |avail|
        sites.all.each do |site|
          avail.add(availability_import_id: import.id, site_id: site.id, avail_date: avail_date_date)
        end
      end
    end
  end

  def update_dates
    import.date_start = body['startDate']
    import.date_end = body['endDate']
    import.save
  end

  def url
    "http://#{bucket}.s3.amazonaws.com/#{import.facility_id}/#{import.run_id}.json"
  end

  def bucket
    Rails.env == 'production' ? 'availabilities-prd' : 'availabilities-dev'
  end

  def body
    @_body ||= JSON.parse(HTTParty.get(url).body)
  end
end
