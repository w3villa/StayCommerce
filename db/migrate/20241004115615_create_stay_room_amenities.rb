class CreateStayRoomAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_room_amenities do |t|
      t.references :room, null: false, foreign_key: { to_table: :stay_rooms }
      t.references :amenity, null: false, foreign_key: { to_table: :stay_amenities }
      t.timestamps
    end
  end
end
