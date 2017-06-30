class FacilitySerializer < ActiveModel::Serializer
  attributes :id, :name, :agency_id, :type, :details
end
