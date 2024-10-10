class AddColumnsToStayRooms < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_rooms, :status, :string
  end
end
