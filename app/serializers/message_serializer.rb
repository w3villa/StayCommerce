class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :sender_id, :receiver_id, :chat_id

end