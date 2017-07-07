class ImportAvailabilities::RecreationGov
  attr_reader :facility_id, :import

  def initialize(facility_id, import)
    @facility_id = facility_id
    @import = import
  end

  def import
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
    "http://availabilities-dev.s3.amazonaws.com/#{facility_id}/#{import}.json"
  end

  def body
    @_body ||= JSON.parse(HTTParty.get(url).body)
  end
end
