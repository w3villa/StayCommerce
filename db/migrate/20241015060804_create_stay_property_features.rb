class CreateStayPropertyFeatures < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_property_features do |t|
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }
      t.references :feature, null: false, foreign_key: { to_table: :stay_features }
      t.timestamps
    end
  end
end
