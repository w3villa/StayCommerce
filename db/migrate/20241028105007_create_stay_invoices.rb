class CreateStayInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_invoices do |t|
      t.references :booking, null: false, foreign_key: { to_table: :stay_bookings }
      t.datetime :invoice_period
      t.string :invoice_type
      t.string :billing_type
      t.boolean :status
      t.decimal :subtotal, default: 0.0
      t.decimal :total, default: 0.0
      t.decimal :discount_amount, default: 0.0
      t.timestamps
    end
  end
end
