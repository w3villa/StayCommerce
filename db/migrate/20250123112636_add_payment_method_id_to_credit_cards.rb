class AddPaymentMethodIdToCreditCards < ActiveRecord::Migration[8.0]
  def change
    add_column :stay_credit_cards, :payment_method_token, :string, null: true
    add_column :stay_credit_cards, :card_token, :string, null: true
  end
end
