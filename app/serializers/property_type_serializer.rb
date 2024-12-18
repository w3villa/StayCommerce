class PropertyTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :property_count

  def property_count
    object.properties.count
  end
end
