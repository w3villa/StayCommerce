class CreateStayPaymentMethods < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_payment_methods do |t|
      t.string :name

      t.timestamps
    end
  end
end
