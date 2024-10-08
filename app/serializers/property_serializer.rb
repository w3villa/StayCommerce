class PropertySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :availability_start, :availability_end, :guest_number, :bedroom_description,
              :university_nearby, :about_neighbourhoods, :instant_booking, :minimum_days_of_booking, :security_deposit, :extra_guest,
              :allow_extra_guest, :city, :address, :latitude ,:longitude, :total_rooms, :total_bathrooms, :property_size,
              :amenities

  belongs_to :property_category, Serializer: :PropertyCategorySerializer
  has_many :rooms,  Serializer: :RoomSerializer
  has_many :additional_rules
  has_many :house_rules

  def amenities
    ActiveModelSerializers::SerializableResource.new(object.amenities, each_serializer: Amenityerializer)
  end
end