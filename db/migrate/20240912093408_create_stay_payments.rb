class CreateStayPayments < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_payments do |t|
      t.references :booking, null: false, foreign_key: { to_table: :stay_bookings }
      t.references :payment_method, null: false, foreign_key: { to_table: :stay_payment_methods }
      t.string :amount, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
