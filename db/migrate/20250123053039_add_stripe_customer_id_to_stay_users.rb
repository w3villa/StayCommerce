class AddStripeCustomerIdToStayUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :stay_users, :stripe_customer_id, :string
  end
end
