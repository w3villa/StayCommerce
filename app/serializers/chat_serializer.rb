class ChatSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :receiver_id, :unread_count, :property

  def property
    PropertyListingSerializer.new(object.property)
  end

  def unread_count
    scope&.dig(:current_user)&.id && object.messages.where(receiver_id: scope[:current_user].id, read_at: nil).count
  end
end
