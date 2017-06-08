module Import::RecreationGov
  class Sites
    attr_reader :facility
    def initialize(facility)
      @facility = facility
    end

    def import(reset = false)
      delete_all if reset

      url = 'https://www.recreation.gov/campsiteSearch.do?contractCode=NRSO&parkId=70923&xml=true'
      r = HTTParty.get(url)
      b = r.body
      h = Hash.from_xml(b)
      h['resultset']['result'].each do |set|
        s = Site.create(
          facility_id: facility.id,
          ext_site_id: set['SiteId'],
          site_num: set['Site'],
          details: set
        )
        puts s
      end
    end

    def delete_all
      facility.sites.delete_all
    end
  end
end
