class CreateStayPrices < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_prices do |t|
      t.bigint :room_id, null: false
      t.decimal :amount, precision: 10, scale: 2
      t.string :currency
      t.datetime :deleted_at
      t.decimal :compare_at_amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
