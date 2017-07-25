class Facility::ReserveAmerica < Facility
  def park_id
    details['park_id']
  end

  def sub_name
    [agency.name, details['state']].join(', ')
  end
end
