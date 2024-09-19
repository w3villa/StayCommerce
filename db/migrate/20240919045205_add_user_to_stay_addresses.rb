class AddUserToStayAddresses < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_addresses, :user, foreign_key: { to_table: :stay_users }
  end
end
