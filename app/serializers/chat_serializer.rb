class ChatSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :receiver_id, :sender, :receiver, :unread_count, :property

  def property
    PropertyListingSerializer.new(object.property)
  end

  def unread_count
    scope&.dig(:current_user)&.id && object.messages.where(receiver_id: scope[:current_user].id, read_at: nil).count
  end

  def sender
    if object.sender_id.present?
      {
        id: object.sender_id,
        name: object.sender.first_name
      }
    end
  end

  def receiver
    if object.receiver_id.present?
      {
        id: object.receiver_id,
        name: object.receiver.first_name
      }
    end
  end
end
