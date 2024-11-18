class RenameColumnsInStayProperties < ActiveRecord::Migration[7.2]
  def change
    rename_column :stay_properties, :price_per_night, :price_per_month
    rename_column :stay_properties, :minimum_days_of_booking, :minimum_months_of_booking
    rename_column :stay_rooms, :price_per_night, :price_per_month
  end
end
