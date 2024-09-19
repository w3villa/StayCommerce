class RenameStatusToStateInStayPayments < ActiveRecord::Migration[7.2]
  def change
    rename_column :stay_payments, :status, :state
  end
end
