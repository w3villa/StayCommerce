class AddPricePerNightInStayProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_properties, :price_per_night, :decimal, precision: 10, scale: 6
  end
end
