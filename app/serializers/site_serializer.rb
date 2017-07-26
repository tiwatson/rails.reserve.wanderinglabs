class SiteSerializer < ActiveModel::Serializer
  attributes :id, :site_num, :site_type, :water, :sewer, :electric, :length, :loop, :site_type2

  def loop
    object.details['Loop']
  end

  def site_type2
    object.details['SiteType']
  end
end
