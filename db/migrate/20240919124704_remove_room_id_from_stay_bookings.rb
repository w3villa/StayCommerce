class RemoveRoomIdFromStayBookings < ActiveRecord::Migration[7.2]
  def change
    remove_column :stay_bookings, :room_id, :integer
  end
end
