InitialImport::RecreationGov::Facilities.perform

InitialImport::RecreationGov::Sites.new(facility).import

InitialImport::RecreationGov::BookingWindow.new(facility).find




Facility.where(sites_counter: 0).each_with_index do |facility, x|
  puts "#{x} Facility: #{facility.id} - #{facility.name}"
  InitialImport::RecreationGov::Sites.new(facility).import
end
