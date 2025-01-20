class BookingSerializer < ActiveModel::Serializer
  attributes  :id, :number, :calculate_totals, :tax_total, :total, :total_amount, :item_total, :room_count, :check_in_date, :check_out_date,
              :number_of_guests, :completed_at, :payment_state, :calculate_city_fee, :calculate_cleaning_fee, :status, :invoice_total, :extra_guest_amount, :last_five_messages
  belongs_to :property, serializer: PropertyListingSerializer
  belongs_to :user,  serializer: UserListingSerializer
  has_many :line_items, serializer: LineItemSerializer
  has_one :chat
  has_one :invoice, serializer: InvoiceSerializer
  has_one :booking_query, serializer: BookingQuerySerializer

  def check_in_date
    object.check_in_date.strftime("%B %d, %Y")
  end

  def check_out_date
    object.check_out_date.strftime("%B %d, %Y")
  end

  def completed_at
    object.completed_at
  end

  def total
    object.total_amount
  end

  def calculate_totals
    object.calculate_totals
  end

  def room_count
    object.rooms.count
  end

  def tax_total
    object.calculate_tax_total
  end

  def extra_guest_amount
    object.extra_guest_amount
  end

  def invoice_total
    object.invoice&.total
  end

  def calculate_cleaning_fee
    object.property.cleaning_fee
  end

  def calculate_city_fee
    object.property.city_fee
  end

  def last_five_messages
    return nil unless object&.chat
    return nil unless object&.chat&.messages.any?
    messages = if scope&.dig(:current_user)&.stay_user?
      object.chat.messages.where(event_for: [ "student", "both" ])
    elsif scope&.dig(:current_user)&.stay_host?
      object.chat.messages.where(event_for: [ "host", "both" ])
    else
      object.chat.messages
    end
    last_five = messages.last(5)
    ActiveModelSerializers::SerializableResource.new(last_five, each_serializer: MessageSerializer)
  end
end
