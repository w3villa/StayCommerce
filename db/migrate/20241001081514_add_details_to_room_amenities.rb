class AddDetailsToRoomAmenities < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_room_amenities, :description, :text
    add_column :stay_room_amenities, :position, :integer
    add_column :stay_room_amenities, :active, :boolean, default: true
    add_column :stay_room_amenities, :extra_charge, :decimal, precision: 8, scale: 2
  end
end
