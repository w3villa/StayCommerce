class CreateStayPropertiesTaxons < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_properties_taxons do |t|
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }
      t.references :taxon, null: false, foreign_key: { to_table: :stay_taxons }
      t.integer :position

      t.timestamps
    end
  end
end
