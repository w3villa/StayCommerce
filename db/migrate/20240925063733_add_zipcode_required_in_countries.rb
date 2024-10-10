class AddZipcodeRequiredInCountries < ActiveRecord::Migration[7.2]
  def change
     add_column :stay_countries, :zipcode_required, :boolean, default: false
  end
end
