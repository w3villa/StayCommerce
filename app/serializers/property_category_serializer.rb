class PropertyCategorySerializer < ActiveModel::Serializer

  attributes :id , :name, :property_type, :room_type

  def property_type
    PropertyTypeSerializer.new(object.property_type)
  end

  def room_type    
    RoomTypeSerializer.new(object.room_type)
  end

end