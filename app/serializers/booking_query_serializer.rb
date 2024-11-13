class BookingQuerySerializer < ActiveModel::Serializer

  attributes :id, :state, :query, :query_for, :guest_count, :check_in_date, :check_out_date
  belongs_to :property, serializer: PropertyListingSerializer
  belongs_to :chat
end