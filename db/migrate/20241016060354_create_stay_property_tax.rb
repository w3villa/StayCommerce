class CreateStayPropertyTax < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_property_taxes do |t|
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }
      t.references :tax, null: false, foreign_key: { to_table: :stay_taxes }
      t.float :value

      t.timestamps
    end
  end
end
