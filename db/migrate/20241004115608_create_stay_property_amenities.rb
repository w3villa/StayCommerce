class CreateStayPropertyAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_property_amenities do |t|
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }
      t.references :amenity, null: false, foreign_key: { to_table: :stay_amenities }
      t.timestamps
    end
  end
end
