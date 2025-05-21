class AddNewFieldToStayProperties < ActiveRecord::Migration[7.2]
  def change
    remove_column :stay_properties, :state, :string
    remove_column :stay_properties, :property_state, :string
    add_column :stay_properties, :state, :string
    add_column :stay_properties, :property_state, :string, default: 'waiting_for_approval'
  end
end
