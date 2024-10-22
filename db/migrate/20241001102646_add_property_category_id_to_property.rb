class AddPropertyCategoryIdToProperty < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_properties, :property_category, foreign_key: { to_table: :stay_property_categories }, null: true
  end
end
