class ChatSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :receiver_id, :sender, :receiver, :last_message,:last_message_time, :unread_count, :property

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
        name: object.sender.first_name,
        image: object.sender.profile_image.present? ? object.sender.profile_image.url : nil
      }
    end
  end

  def receiver
    if object.receiver_id.present?
      {
        id: object.receiver_id,
        name: object.receiver.first_name,
        image: object.receiver.profile_image.present? ? object.receiver.profile_image.url : nil
      }
    end
  end

  def last_message
    object.messages.any? ? object.messages.last.body : nil
  end

  def last_message_time
    object.messages.any? ? object.messages.last.created_at : nil
  end

end
