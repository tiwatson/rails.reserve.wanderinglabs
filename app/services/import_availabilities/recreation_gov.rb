class ImportAvailabilities::RecreationGov
  attr_reader :facility_id, :import, :body

  def initialize(facility_id, import, body)
    @facility_id = facility_id
    @import = import
    @body = JSON.parse(body)
  end

  def perform
    # TODO: Prefetch exit_side_id to site.id lookup
    body.each do |avail_date, ext_sites|
      puts "avail_date - #{avail_date}"
      avail_date_date = Date.strptime(avail_date, '%m/%d/%Y')
      puts "avail_date_date - #{avail_date_date.month}"

      sites = Site.where(facility_id: facility_id).where(ext_site_id: ext_sites)
      Availability.bulk_insert do |avail|
        sites.all.each do |site|
          avail.add(facility_id: facility_id, site_id: site.id, import: import, avail_date: avail_date_date)
        end
      end
      AvailabilityMatcher::Index.perform(import, facility_id)
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

  def self.perform(url)
    # http://availabilities-dev.s3.amazonaws.com/10612/17_06_08_17_22.json
    facility_id = url.split('/')[3]
    import = url.split('/')[4].gsub('.json', '')
    body = HTTParty.get(url).body
    new(facility_id, import, body).perform
  end
end
