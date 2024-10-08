class CreateStayTaxons < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_taxons do |t|

      t.bigint :parent_id, index: true
      t.integer :position, default: 0, index: true
      t.string :name, index: true
      t.string :permalink
      t.bigint :taxonomy_id, index: true
      t.bigint :lft, index: true
      t.bigint :rgt, index: true
      t.text :description
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords
      t.integer :depth
      t.boolean :hide_from_nav, default: false
      t.json :public_metadata
      t.json :private_metadata
      t.string :pretty_name, index: true

      t.timestamps
    end
  end
end
