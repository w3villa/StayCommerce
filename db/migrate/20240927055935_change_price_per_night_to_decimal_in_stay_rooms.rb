class ChangePricePerNightToDecimalInStayRooms < ActiveRecord::Migration[7.2]
  def change
    change_column :stay_rooms, :price_per_night, :decimal, precision: 10, scale: 2
  end
end
