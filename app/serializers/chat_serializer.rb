class ChatSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :receiver_id, :property

  def property
    PropertyListingSerializer.new(object.property)
  end
end
