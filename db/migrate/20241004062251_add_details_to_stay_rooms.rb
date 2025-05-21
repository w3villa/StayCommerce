class AddDetailsToStayRooms < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_rooms, :booking_start, :datetime
    add_column :stay_rooms, :booking_end, :datetime
    add_column :stay_rooms, :description, :text
    add_column :stay_rooms, :size, :integer
    add_reference :stay_rooms, :bed_type, foreign_key: { to_table: :stay_bed_types }, null: true
  end
end
