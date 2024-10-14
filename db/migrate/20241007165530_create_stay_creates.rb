class CreateStayCreates < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_property_house_rules do |t|
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }
      t.references :house_rule, null: false, foreign_key: { to_table: :stay_house_rules }
      t.string :value
      t.timestamps
    end
  end
end
