class Facility::RecreationGov < Facility
  def contract_code
    'NRSO'
  end

  def park_id
    details['LegacyFacilityID'].to_i.to_s
  end

  def sub_name
    [details['Parent'], details['AddressStateCode']].join(', ')
  end
end
