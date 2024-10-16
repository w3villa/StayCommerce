class CreateStayTaxonomies < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_taxonomies do |t|
      t.string :name, null: false
      t.integer :position, default: 0
      t.references :store, null: false, foreign_key: { to_table: :stay_stores }
      t.json :public_metadata
      t.json :private_metadata

      t.timestamps
    end
  end
end
