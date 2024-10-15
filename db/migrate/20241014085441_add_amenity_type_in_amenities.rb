class AddAmenityTypeInAmenities < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_amenities, :amenity_type, :integer,  null: false
  end
end
