InitialImport::RecreationGov::Facilities.perform

InitialImport::RecreationGov::Sites.new(facility).import

InitialImport::RecreationGov::BookingWindow.new(facility).find



ActiveRecord::Base.logger.level = 1

Facility.where(sites_count: 0).each_with_index do |facility, x|
  puts "#{x} Facility: #{facility.id} - #{facility.name}"
  begin
    InitialImport::RecreationGov::Sites.new(facility).import
  rescue
    facility.update_attributes(status: :required_attention)
  end
end
