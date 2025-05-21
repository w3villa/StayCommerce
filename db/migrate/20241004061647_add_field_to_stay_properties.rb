class AddFieldToStayProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_properties, :guest_number, :integer
    add_column :stay_properties, :bedroom_description, :text
    add_column :stay_properties, :university_nearby, :string
    add_column :stay_properties, :about_neighbourhoods, :text
    add_column :stay_properties, :instant_booking, :boolean, default: false
    add_column :stay_properties, :minimum_days_of_booking, :integer
    add_column :stay_properties, :security_deposit, :decimal, precision: 10, scale: 2
    add_column :stay_properties, :extra_guest, :integer
    add_column :stay_properties, :allow_extra_guest, :boolean, default: false
    add_column :stay_properties, :city, :string
    add_column :stay_properties, :address, :string
    add_column :stay_properties, :latitude, :decimal, precision: 10, scale: 6
    add_column :stay_properties, :longitude, :decimal, precision: 10, scale: 6
    add_column :stay_properties, :total_rooms, :integer
    add_column :stay_properties, :total_bathrooms, :integer
    add_column :stay_properties, :property_size, :string
  end
end
