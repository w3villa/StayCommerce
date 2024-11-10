class Last5MessagesSerializer < ActiveModel::Serializer
  attributes :last_five_messages

  def last_five_messages
    ActiveModelSerializers::SerializableResource.new(object, each_serializer: MessageSerializer)
  end
end
