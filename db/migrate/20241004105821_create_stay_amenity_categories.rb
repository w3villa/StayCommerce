class CreateStayAmenityCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_amenity_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
