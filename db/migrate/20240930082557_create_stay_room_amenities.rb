class CreateStayRoomAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_room_amenities do |t|
      t.references :stay_room, null: false, foreign_key: true
      t.references :stay_amenity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
