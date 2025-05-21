class CreateStayStayCreditCards < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_credit_cards do |t|
      t.string :month
      t.string :year
      t.string :cc_type
      t.string :cc_number
      t.string :name
      t.string :brand
      t.boolean :default
      t.references :payment_method, null: true, foreign_key: { to_table: :stay_payment_methods }
      t.references :user, null: false, foreign_key: { to_table: :stay_users }
      t.timestamps
    end
  end
end
