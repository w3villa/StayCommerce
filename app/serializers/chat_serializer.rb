class ChatSerializer < ActiveModel::Serializer
  attributes :id, :property, :sender_id, :receiver_id

  def property
    PropertyListingSerializer.new(object.property)
  end
end
