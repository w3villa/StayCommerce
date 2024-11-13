class LineItemSerializer < ActiveModel::Serializer

  attributes :id , :check_in, :check_out, :price, :room_id
  belongs_to :room, Serializer: RoomSerializer

end