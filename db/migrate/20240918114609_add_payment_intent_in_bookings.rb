class AddPaymentIntentInBookings < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_bookings, :payment_intent_id, :string
    add_column :stay_bookings, :total_amount, :decimal, precision: 10, scale: 2
  end
end
