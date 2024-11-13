class CreateStayDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_discounts do |t|
      t.references :invoice, null: false, foreign_key: { to_table: :stay_invoices }
      t.string :description, null: false 
      t.decimal :amount,  null: false
      t.timestamps
    end
  end
end
