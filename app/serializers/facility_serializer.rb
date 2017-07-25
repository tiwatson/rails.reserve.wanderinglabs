class FacilitySerializer < ActiveModel::Serializer
  attributes :id, :name, :agency_id, :type, :sub_name
end
