module InitialImport::ReserveAmerica
  class Facilities
    attr_accessor :agency

    def initialize(agency)
      @agency = agency
    end

    def all_facilities
      facilities = []
      start = 0
      loop do
        puts "AGENCY - #{agency.inspect}"
        url = "#{agency.details['url']}&startIdx=#{start}"
        facilities = FacilitiesListings.new(url).facilities

        facilities.each do |facility_attrs|
          update_or_create(facility_attrs)
        end
        break if facilities.size < 25

        start += 25
      end
    end

    def update_or_create(attrs)
      Facility.where(name: attrs[:name]).first_or_create(attrs.merge(agency_id: agency.id))
    end
  end
end
