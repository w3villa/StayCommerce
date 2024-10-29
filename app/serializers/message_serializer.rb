class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :event_message, :event_for, :sender_id, :receiver_id, :sender, :receiver

  
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
