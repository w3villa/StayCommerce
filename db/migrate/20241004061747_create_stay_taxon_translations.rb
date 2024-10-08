class CreateStayTaxonTranslations < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_taxon_translations do |t|
      t.string "name"
      t.text "description"
      t.string "locale", null: false
      t.references :stay_taxon, index: true, foreign_key: { to_table: :stay_taxons }
      t.string "meta_title"
      t.string "meta_description"
      t.string "meta_keywords"
      t.string "permalink"
      t.string "pretty_name"

      t.timestamps
    end
  end
end
