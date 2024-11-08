class BookingSerializer < ActiveModel::Serializer
  attributes :id, :number, :total, :room_count, :check_in_date, :check_out_date, :number_of_guests, :completed_at, :payment_state, :status
  belongs_to :property, serializer: PropertyListingSerializer
  belongs_to :user
  has_many :line_items, Serializer: LineItemSerializer
  has_one :chat
  has_one :invoice, Serializer: InvoiceSerializer

  def completed_at
    object.completed_at
  end

  def total
    object.total_amount
  end

  def room_count
    object.rooms.count
  end

end