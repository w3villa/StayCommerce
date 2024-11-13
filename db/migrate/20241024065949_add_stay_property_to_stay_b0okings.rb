class AddStayPropertyToStayB0okings < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_bookings, :property, foreign_key: { to_table: :stay_properties }, null: true
  end
end
