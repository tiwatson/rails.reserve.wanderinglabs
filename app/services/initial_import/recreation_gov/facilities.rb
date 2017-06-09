module InitialImport::RecreationGov
  class Facilities
    require 'httparty'

    def self.perform
      puts "Activities: #{activities_data.size} - #{activities_data[0]}"
      puts "Existing: #{agency.facilities.count} Import: #{rec_data.size}"

      rec_data.each_with_index do |data, x|
        puts "#{x}: #{data['FacilityName']}"
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
      @_rec_data ||= JSON.parse(rec_data_json)['RECDATA'].select do |r|
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
      @_activities_data ||= JSON.parse(activities_data_json)['RECDATA'].select do |r|
        r['ActivityID'].to_i == 9 && r['EntityType'] == 'Facility'
      end
    end

    def self.rec_data_json
      if Rails.env.development?
        File.open('db/data/recreation_gov/Facilities_API_v1.json').read
      else
        HTTParty.get('http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/Facilities_API_v1.json').body
      end
    end

    def self.activities_data_json
      if Rails.env.development?
        File.open('db/data/recreation_gov/EntityActivities_API_v1.json').read
      else
        HTTParty.get('http://availabilities-dev.s3.amazonaws.com/recreation_gov_data/EntityActivities_API_v1.json').body
      end
    end
  end
end
