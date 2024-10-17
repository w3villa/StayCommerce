class CreateStayRoomFeatures < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_room_features do |t|
      t.references :room, null: false, foreign_key: { to_table: :stay_rooms }
      t.references :feature, null: false, foreign_key: { to_table: :stay_features }
      t.timestamps
    end
  end
end
