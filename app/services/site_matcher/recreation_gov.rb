module SiteMatcher
  class RecreationGov
    # given filter details about the site reuqested... return a list of matching sites
    attr_reader :facility_id, :site_details
    def initialize(facility_id, site_details)
      @facility_id = facility_id
      @site_details = site_details
    end

    def matching_site_ids
      facility.sites.where('details @> ?', details).all.map(&:id)
    end

    def details
      site_details ? site_details.to_json : '{}'
    end

    def facility
      @_facility ||= Facility.find(facility_id)
    end
  end
end
