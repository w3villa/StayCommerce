class AddPropertyTypeIdToStayPropertyCategories < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_property_categories, :property_type, foreign_key: { to_table: :stay_property_types }, null: true
    add_reference :stay_property_categories, :room_type, foreign_key: { to_table: :stay_room_types }, null: true
  end
end
