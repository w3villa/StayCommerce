class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :event_message, :event_for, :sender_id, :receiver_id, :sender, :receiver, :read?, :attachments, :created_at

  def body
    if object.body.blank? && object.attachments.any?
      attachment = object.attachments.last
      content_type = attachment.blob.content_type

      if content_type.start_with?("image/")
        attachment.blob.filename.to_s
      elsif content_type.start_with?("video/")
        attachment.blob.filename.to_s
      else
        attachment.blob.filename.to_s
      end
    else
      object.body
    end
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

  def attachments
    object.attachments.attached? ? object.attachments_urls : []
  end
end
