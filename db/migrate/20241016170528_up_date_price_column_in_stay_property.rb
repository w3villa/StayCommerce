class UpDatePriceColumnInStayProperty < ActiveRecord::Migration[7.2]
  def change
    change_column :stay_properties, :price_per_night, :decimal, precision: 15, scale: 10
  end
end
