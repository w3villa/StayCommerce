class AddNewFieldsToProperty < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_properties, :taxes_in_percentage, :decimal
    add_column :stay_properties, :cleaning_fee, :decimal
    add_column :stay_properties, :city_fee, :decimal
    add_column :stay_properties, :early_bird_discount, :decimal
    add_column :stay_properties, :advance_days, :integer
    add_column :stay_properties, :is_city_fee_percentage, :boolean, default: false
    add_column :stay_properties, :unlimited_availability, :boolean, default: false
  end
end
