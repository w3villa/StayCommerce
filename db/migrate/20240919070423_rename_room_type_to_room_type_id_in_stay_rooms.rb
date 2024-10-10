class RenameRoomTypeToRoomTypeIdInStayRooms < ActiveRecord::Migration[7.2]
  def change
    rename_column :stay_rooms, :room_type, :room_type_id
  end
end
