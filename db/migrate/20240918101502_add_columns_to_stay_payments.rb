class AddColumnsToStayPayments < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_payments, :source_type, :string
    add_column :stay_payments, :source_id, :integer
    add_column :stay_payments, :response_code, :string
    add_column :stay_payments, :avs_response, :string
    add_column :stay_payments, :number, :string
    add_column :stay_payments, :cvv_response_code, :string
    add_column :stay_payments, :cvv_response_message, :string
    add_column :stay_payments, :public_metadata, :json
    add_column :stay_payments, :private_metadata, :json
    add_column :stay_payments, :intent_client_key, :string
    add_column :stay_payments, :transaction_id, :string
    add_column :stay_payments, :preferences, :json

    rename_column :stay_payments, :status, :state
  end
end
