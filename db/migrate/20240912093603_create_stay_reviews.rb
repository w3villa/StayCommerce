class CreateStayReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_reviews do |t|
      t.references :booking, null: false, foreign_key: { to_table: :stay_bookings }
      t.integer :rating, null: false
      t.string :comment

      t.timestamps
    end
  end
end
