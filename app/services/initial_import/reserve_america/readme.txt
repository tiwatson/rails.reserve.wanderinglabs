InitialImport::ReserveAmerica::Agencies.import




ActiveRecord::Base.logger.level = 1

Facility::ReserveAmerica.where(sites_count: 0).each_with_index do |facility, x|
  puts "#{x} Facility: #{facility.id} - #{facility.name}"
  begin
    InitialImport::ReserveAmerica::Sites.new(facility).import
  rescue
    puts "RESCUED.................."
    facility.update_attributes(status: :requires_attention)
  end
end


Facility::ReserveAmerica.where('sites_count > 0').where(booking_window: nil).each_with_index do |facility, x|
  puts "#{x} Facility: #{facility.id} - #{facility.name}"
  begin
    InitialImport::ReserveAmerica::BookingWindow.new(facility).find
  rescue
    puts "RESCUED.................."
    facility.update_attributes(status: :requires_attention)
  end
end

