class RemoveRoomIdFromStayProperties < ActiveRecord::Migration[7.2]
  def change
    remove_column :stay_properties, :room_id, :integer
  end
end
