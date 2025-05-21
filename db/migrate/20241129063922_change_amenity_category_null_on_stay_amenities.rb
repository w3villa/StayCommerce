class ChangeAmenityCategoryNullOnStayAmenities < ActiveRecord::Migration[7.2]
  def change
    change_column_null :stay_amenities, :amenity_category_id, true
  end
end
