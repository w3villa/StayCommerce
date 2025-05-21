class AddSlugToStayProperties < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_properties, :slug, :string
    add_index :stay_properties, :slug, unique: true
  end
end
