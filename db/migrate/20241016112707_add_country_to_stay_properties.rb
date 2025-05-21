class AddCountryToStayProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_properties, :country, :string
    add_column :stay_properties, :state, :string
  end
end
