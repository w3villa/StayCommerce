class AddColumnToStayProperty < ActiveRecord::Migration[7.2]
  def change
    add_reference :stay_properties, :property_type, foreign_key: { to_table: :stay_property_types }, null: true
  end
end
