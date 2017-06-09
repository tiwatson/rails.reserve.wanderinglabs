module InitialImport::RecreationGov
  class BookingWindow
    attr_reader :facility
    def initialize(facility)
      @facility = facility
    end

    def url
      site_id = facility.sites.first&.ext_site_id
      return if site_id.nil?
      "https://www.recreation.gov/camping/Watchman_Campground/r/campsiteDetails.do?siteId=#{site_id}&contractCode=NRSO&parkId=#{facility.park_id}&offset=0&arvdate=1/1/2020&lengthOfStay=1"
    end

    def find
      r_url = url
      return if r_url.nil?
      r = HTTParty.get(r_url)
      b = r.body
      d = b.match(/Select arrival date before ([0-9a-zA-Z\s]*)/)[1]
      return unless d.present?
      window = (Date.parse(d, '%a %b %d %Y') - Date.today).to_i
      return unless window.positive?
      facility.update_attributes(booking_window: window)
      nil
    end
  end
end
