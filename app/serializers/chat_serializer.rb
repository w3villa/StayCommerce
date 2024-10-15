class ChatSerializer < ActiveModel::Serializer
  attributes :id, :property, :sender, :receiver
  
  def sender
    object.sender
  end

  def receiver
    object.receiver
  end

  def property
    # binding.pry
    PropertyListingSerializer.new(object.property)
  end

end