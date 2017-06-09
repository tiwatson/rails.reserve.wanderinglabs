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
      @_address_data ||= JSON.parse(address_data_json)['RECDATA']
    end

    def self.organization_linking_data
      @_organization_linking_data ||= JSON.parse(organization_linking_data_json)['RECDATA']
    end

    def self.organization_data
      @_organization_data ||= JSON.parse(organization_data_json)['RECDATA']
    end

    def self.address_data_json
      if Rails.env.development?
        File.open('db/data/recreation_gov/FacilityAddresses_API_v1.json').read
      else
        HTTParty.get('http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/FacilityAddresses_API_v1.json').body
      end
    end

    def self.organization_linking_data_json
      if Rails.env.development?
        File.open('db/data/recreation_gov/OrgEntities_API_v1.json').read
      else
        HTTParty.get('http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/OrgEntities_API_v1.json').body
      end
    end

    def self.organization_data_json
      if Rails.env.development?
        File.open('db/data/recreation_gov/Organizations_API_v1.json').read
      else
        HTTParty.get('http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/Organizations_API_v1.json').body
      end
    end
  end
end
