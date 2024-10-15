class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :sender, :receiver, :chat
  belongs_to :chat

  def sender
    object.sender
  end

  def receiver
    object.receiver
  end

end