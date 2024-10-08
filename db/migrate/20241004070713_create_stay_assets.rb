class CreateStayAssets < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_assets do |t|
      t.string :viewable_type
      t.bigint :viewable_id
      t.integer :attachment_width
      t.integer :attachment_height
      t.integer :attachment_file_size
      t.integer :position
      t.string :attachment_content_type
      t.string :attachment_file_name
      t.string :type, limit: 75
      t.datetime :attachment_updated_at
      t.text :alt
      t.json :public_metadata
      t.json :private_metadata

      t.timestamps
    end
  end
end
