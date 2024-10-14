class ChatSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :receiver_id, :property_id

end