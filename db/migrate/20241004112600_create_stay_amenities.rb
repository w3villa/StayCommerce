class CreateStayAmenities < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_amenities do |t|
      t.string :name
      t.references :amenity_category, null: false, foreign_key: { to_table: :stay_amenity_categories }
      t.timestamps
    end
  end
end
