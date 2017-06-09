module InitialImport::RecreationGov
  class Facilities
    require 'httparty'
    FACILITIES_URL = 'http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/Facilities_API_v1.json'.freeze
    ENTITYACTIVITY_URL = 'http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/EntityActivities_API_v1.json'.freeze

    def self.perform
      puts "Activities: #{activities_data.size} - #{activities_data[0]}"
      puts "Existing: #{agency.facilities.count} Import: #{rec_data.size}"

      rec_data.each do |data|
        facility = agency.facilities.find_or_initialize_by(name: data['FacilityName'])
        details = InitialImport::RecreationGov::FacilityDetails.new(data).details
        facility.update_attribute(:details, details)
      end
      puts "Now: #{agency.reload.facilities.count}"
      nil
    end

    def self.facilities_id_from_camping_activities
      @_facilities_id_from_camping_activities ||= activities_data.map { |e| e['EntityID'] }
    end

    def self.rec_data
      @_rec_data ||= JSON.parse(HTTParty.get(FACILITIES_URL).body)['RECDATA'].select do |r|
        facilities_id_from_camping_activities.include?(r['FacilityID']) &&
          r['LegacyFacilityID'].present? &&
          r['LegacyFacilityID'].to_i.positive? &&
          r['LegacyFacilityID'].to_i != 372_045
      end
    end

    def self.agency
      @_agency ||= Agency.find_or_create_by(name: 'RecreationGov')
    end

    def self.activities_data
      @_activities_data ||= JSON.parse(HTTParty.get(ENTITYACTIVITY_URL).body)['RECDATA'].select do |r|
        r['ActivityID'].to_i == 9 && r['EntityType'] == 'Facility'
      end
    end
  end
end
