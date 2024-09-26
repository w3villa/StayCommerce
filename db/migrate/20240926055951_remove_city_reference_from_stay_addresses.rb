class RemoveCityReferenceFromStayAddresses < ActiveRecord::Migration[7.2]
  def change
    remove_reference :stay_addresses, :city, foreign_key: { to_table: :stay_cities }
  end
end
