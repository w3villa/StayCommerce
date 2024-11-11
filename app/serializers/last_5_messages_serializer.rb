class Last5MessagesSerializer < ActiveModel::Serializer
  attributes :last_five_messages

  def last_five_messages
    object.any? ? ActiveModelSerializers::SerializableResource.new(object, each_serializer: MessageSerializer) : nil
  end
end
