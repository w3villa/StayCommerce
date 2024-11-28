class AddNameToStayRooms < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_rooms, :name, :string
  end
end
