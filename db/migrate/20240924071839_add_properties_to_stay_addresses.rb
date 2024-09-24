class AddPropertiesToStayAddresses < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_addresses, :property, foreign_key: { to_table: :stay_properties }
  end
end
