class AddFirstNameToStayAddresses < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_addresses, :firstname, :string
    add_column :stay_addresses, :lastname, :string
    add_column :stay_addresses, :phone, :string
    add_column :stay_addresses, :alternative_phone, :string
  end
end
