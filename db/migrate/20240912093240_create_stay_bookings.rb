class CreateStayBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_bookings do |t|
      t.references :user, null: false, foreign_key: { to_table: :stay_users }
      t.references :room, null: false, foreign_key: { to_table: :stay_rooms }
      t.string :email
      t.date :check_in_date, null: false
      t.date :check_out_date, null: false
      t.integer :number_of_guests, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
