class CreateStayLineItems < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_line_items do |t|
      t.references :booking, null: false, foreign_key: { to_table: :stay_bookings }
      t.references :room, null: false, foreign_key: { to_table: :stay_rooms }
      t.datetime :check_in
      t.datetime :check_out
      t.decimal :price
      t.integer :quantity
      t.string :currency
      t.integer :property_id

      t.timestamps
    end
  end
end
