class BookingSerializer < ActiveModel::Serializer
  attributes :id, :number, :tax_total, :total, :total_amount, :item_total, :room_count, :check_in_date, :check_out_date, :last_five_messages, :number_of_guests, :completed_at, :payment_state, :status
  belongs_to :property, serializer: PropertyListingSerializer
  belongs_to :user
  has_many :line_items, Serializer: LineItemSerializer
  has_one :chat
  has_one :invoice, Serializer: InvoiceSerializer
  has_one :booking_query, Serializer: BookingQuerySerializer

  def completed_at
    object.completed_at
  end

  def total
    object.total_amount
  end

  def room_count
    object.rooms.count
  end

  def tax_total
    object.property.property_taxes.any? ? object.property.property_taxes.uniq { |property_tax| property_tax.tax_id }.pluck(:value).sum : 0
  end

  def last_five_messages
    object.chat.present? && object.chat.messages.any? ? ActiveModelSerializers::SerializableResource.new(object.chat.messages.limit(5), each_serializer: MessageSerializer) : nil
  end
end
