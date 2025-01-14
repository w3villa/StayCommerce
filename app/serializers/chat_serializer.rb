class ChatSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :receiver_id, :sender, :receiver, :last_message, :last_message_time, :unread_count, :property

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
    last_message = object.messages.last
    return nil unless last_message

    if last_message.body.blank? && last_message.attachments.any?
      attachment = last_message.attachments.last
      content_type = attachment.blob.content_type

      if content_type.start_with?("image/")
        "Image: " + attachment.blob.filename.to_s
      elsif content_type.start_with?("video/")
        "Video: " + attachment.blob.filename.to_s
      else
        attachment.blob.filename.to_s
      end
    else
      last_message.body
    end
  end

  def last_message_time
    object.messages.any? ? formatted_date(object.messages.last.created_at) : nil
  end

  private

  def formatted_date(date)
    if date.to_date == Date.today
      date.strftime("%H:%M %p")
    elsif date.to_date == Date.yesterday
      date.strftime("%m/%d")
    else
      date.strftime("%-m/%d/%Y")
    end
  end
end
