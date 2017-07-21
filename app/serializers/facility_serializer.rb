class FacilitySerializer < ActiveModel::Serializer
  attributes :id, :name, :agency_id, :type, :sub_name

  def sub_name
    [object.details['Parent'], object.details['AddressStateCode']].join(', ')
  end
end
