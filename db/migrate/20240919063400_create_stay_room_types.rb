class CreateStayRoomTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_room_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
