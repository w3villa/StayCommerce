class CreateStayBookingQueries < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_booking_queries do |t|
      t.datetime :check_in_date
      t.datetime :check_out_date
      t.references :chat, null: false, foreign_key: { to_table: :stay_chats }
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }
      t.references :booking, foreign_key: { to_table: :stay_bookings }
      t.references :user, foreign_key: { to_table: :stay_users }
      t.integer :state
      t.text :query
      t.integer :guest_count
      t.json :query_for
      t.timestamps
    end
  end
end
