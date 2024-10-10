class CreateStayRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_rooms do |t|
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }
      t.integer :max_guests, null: false
      t.integer :price_per_night, null: false
      t.integer :room_type, null: false

      t.timestamps
    end
  end
end
