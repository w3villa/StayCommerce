class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :sender, :receiver
  def sender
    {
     id: object.sender_id,
     name: object.sender.first_name
      #  image:  object.sender.profile_image.url || nil
    }
  end

  def receiver
    {
      id: object.receiver_id,
      name: object.receiver.first_name
     }
  end
end
