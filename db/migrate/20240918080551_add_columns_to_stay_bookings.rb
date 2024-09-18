class AddColumnsToStayBookings < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_bookings, :payment_state, :string
    add_column :stay_bookings, :item_total, :decimal
    add_column :stay_bookings, :total, :decimal
    add_column :stay_bookings, :room_count, :integer
    add_column :stay_bookings, :completed_at, :datetime
    add_column :stay_bookings, :canceled_at, :datetime
    add_column :stay_bookings, :canceler_id, :integer
  end
end
