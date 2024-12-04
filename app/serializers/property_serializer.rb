class PropertySerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :booked_dates, :is_shared_property, :availability_start, :availability_end, :guest_number, :bedroom_description,
              :university_nearby, :about_neighbourhoods, :instant_booking, :minimum_months_of_booking, :security_deposit, :extra_guest,
              :allow_extra_guest, :city, :address, :latitude, :longitude, :state, :country, :zipcode, :total_rooms, :total_bathrooms, :property_size,
              :cover_image, :place_images, :price_per_month, :house_rules, :additional_rules, :amenities, :property_taxes,  :features, :cancellation_policy

  belongs_to :property_category, Serializer: :PropertyCategorySerializer
  belongs_to :property_type, Serializer: :PropertyTypeSerializer
  has_many :rooms,  Serializer: :RoomSerializer
  belongs_to :user

  def amenities
    ActiveModelSerializers::SerializableResource.new(object.amenities.property.uniq, each_serializer: AmenitySerializer)
  end

  def features
    ActiveModelSerializers::SerializableResource.new(object.features.property.uniq, each_serializer: PropertyFeatureSerializer)
  end

  def is_shared_property
    object.shared_property
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

  def property_taxes
    object.property_taxes.uniq { |property_tax| property_tax.tax_id }.map do |property_tax|
      {
        id: property_tax.id,
        name: property_tax.tax.name,
        tax_id: property_tax.tax.id,
        value: property_tax.value
      }
    end
  end

  def cancellation_policy
    return nil unless object.cancellation_policy.present?
    CancellationPolicySerializer.new(object.cancellation_policy)
  end

  def booked_dates
    return [] if object.shared_property
    bookings = Stay::Booking.joins(:property).where(stay_properties: { id: object.id })
    bookings.exists? ? bookings.pluck(:check_in_date, :check_out_date).uniq : []
  rescue StandardError => e
    Rails.logger.error("Error fetching bookings for room #{object.id}: #{e.message}")
    []
  end
end
