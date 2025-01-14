class ModifyPropertyCategoryOnProperties < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :stay_properties, :stay_property_categories

    add_foreign_key :stay_properties, :stay_property_categories, column: :property_category_id, on_delete: :nullify
  end
end
