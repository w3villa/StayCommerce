class CreateStayTaxonomyTranslations < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_taxonomy_translations do |t|
      t.string :name
      t.string :locale, null: false
      t.references :stay_taxonomy, index: true, foreign_key: { to_table: :stay_taxonomies }

      t.timestamps
    end
  end
end
