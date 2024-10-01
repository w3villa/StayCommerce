class AddStoreIdToStayBookings < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_bookings, :store, foreign_key: { to_table: :stay_stores }
  end
end
