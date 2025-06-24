class BookingListingSerializer < ActiveModel::Serializer
  attributes :id, :number, :total, :total_amount, :check_in_date, :check_out_date, :item_total, :is_shared_property, :booked_room, :room_images,
  :number_of_guests, :payment_state, :status, :request_by, :invoice_no, :calculate_cleaning_fee, :calculate_city_fee, :extra_guest_amount, :property


  def total
    object.total_amount
  end

  def property
    property =  object.property

    {
      id: property.id,
      title: property.title,
      price_per_month: property.price_per_month,
      city: property.city,
      state: property.state,
      slug: property.slug,
      rooms_count:property.rooms.count,
    }
  end

  def room_images
    object.rooms.last.room_images.map(&:url).compact
  end

  def is_shared_property
    object.property&.shared_property
  end

  def booked_room
    object.line_items.any? ?  object.line_items.last.room&.name : nil
  end

  def calculate_cleaning_fee
    nil #  object.property.cleaning_fee
  end

  def calculate_city_fee
   nil # object.property.city_fee
  end

  def extra_guest_amount
    object.extra_guest_amount
  end

  def check_in_date
    object.check_in_date.strftime("%B %d, %Y")
  end

  def check_out_date
    object.check_out_date.strftime("%B %d, %Y")
  end

  def request_by
    object.user&.full_name || nil
  end

  def invoice_no
    object.invoice ? object.invoice.id : nil
  end

end
