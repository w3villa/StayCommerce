class PropertySerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :availability_start, :availability_end, :guest_number, :bedroom_description,
              :university_nearby, :about_neighbourhoods, :instant_booking, :minimum_days_of_booking, :security_deposit, :extra_guest,
              :allow_extra_guest, :city, :address, :latitude ,:longitude, :total_rooms, :total_bathrooms, :property_size,
              :cover_image, :place_images, :price_per_night, :house_rules, :additional_rules, :amenities

  belongs_to :property_category, Serializer: :PropertyCategorySerializer
  has_many :rooms,  Serializer: :RoomSerializer
  belongs_to :user


  def amenities
    ActiveModelSerializers::SerializableResource.new(object.amenities, each_serializer: AmenitySerializer)
  end

  def house_rules
    object.property_house_rules.map do |rule|
       {
        id: rule.house_rule.id,
        name: rule.house_rule.name,
        value: rule.value
       }
    end
  end

  def cover_image
    object.cover_image_url
  end

  def place_images
    object.place_images.attached? ? object.place_images_urls : []
  end
  
  def additional_rules
    object.additional_rules.map do |rule|
    {
      id: rule.id,
      name: rule.name
    }
    end
  end
end