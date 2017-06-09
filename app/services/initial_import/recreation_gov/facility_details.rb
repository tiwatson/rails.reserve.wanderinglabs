module InitialImport::RecreationGov
  class FacilityDetails
    attr_accessor :attrs
    def initialize(attrs)
      @attrs = attrs.except('FacilityDescription', 'FacilityDirections').reject { |_k, v| v.to_s.scrub.blank? }
    end

    def details
      cleaned_data = attrs.merge(address_match(attrs['FacilityID']))
      cleaned_data = cleaned_data.merge(organization_match(attrs['FacilityID']))
      cleaned_data
    end

    def address_match(facility_id)
      self.class.address_data.select do |r|
        r['FacilityID'] == facility_id
      end.first || {}
    end

    def organization_match(facility_id)
      org_link = self.class.organization_linking_data.select do |r|
        r['EntityID'] == facility_id && r['EntityType'] == 'Facility'
      end.first

      return {} unless org_link.present?

      org = self.class.organization_data.select do |r|
        r['OrgID'] == org_link['OrgID']
      end.first || {}
      org.slice('OrgID', 'OrgName', 'OrgType')
    end

    def self.address_data
      Rails.cache.fetch('address_data') do
        JSON.parse(HTTParty.get('http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/FacilityAddresses_API_v1.json').body)['RECDATA']
      end
    end

    def self.organization_linking_data
      Rails.cache.fetch('organization_linking_data') do
        JSON.parse(HTTParty.get('http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/OrgEntities_API_v1.json').body)['RECDATA']
      end
    end

    def self.organization_data
      Rails.cache.fetch('organization_data') do
        JSON.parse(HTTParty.get('http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/Organizations_API_v1.json').body)['RECDATA']
      end
    end
  end
end
