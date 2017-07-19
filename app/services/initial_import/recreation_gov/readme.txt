InitialImport::RecreationGov::Facilities.perform

InitialImport::RecreationGov::Sites.new(facility).import

InitialImport::RecreationGov::BookingWindow.new(facility).find



ActiveRecord::Base.logger.level = 1

Facility.where(sites_count: 0).each_with_index do |facility, x|
  puts "#{x} Facility: #{facility.id} - #{facility.name}"
  begin
    InitialImport::RecreationGov::Sites.new(facility).import
  rescue
    puts "RESCUED.................."
    facility.update_attributes(status: :requires_attention)
  end
end


Facility.where('sites_count > 0').where(booking_window: nil).each_with_index do |facility, x|
  puts "#{x} Facility: #{facility.id} - #{facility.name}"
  begin
    InitialImport::RecreationGov::BookingWindow.new(facility).find
  rescue
    puts "RESCUED.................."
    facility.update_attributes(status: :requires_attention)
  end
end


Facility.where('details @> ?', {LegacyFacilityID: '75118.0'}.to_json)
