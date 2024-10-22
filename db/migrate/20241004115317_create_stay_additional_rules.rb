class CreateStayAdditionalRules < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_additional_rules do |t|
      t.string :name
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }
      t.timestamps
    end
  end
end
