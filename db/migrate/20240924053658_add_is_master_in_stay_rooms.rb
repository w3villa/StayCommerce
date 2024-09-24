class AddIsMasterInStayRooms < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_rooms, :is_master, :boolean
  end
end
