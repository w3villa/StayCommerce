class RemoveColumnFromStayPropertiesCategories < ActiveRecord::Migration[7.2]
  def change
    remove_column :stay_property_categories, :room_type_id, :bigint
    remove_column :stay_property_categories, :property_type_id, :bigint
  end
end
