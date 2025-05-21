class CreateStayPropertyCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_property_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
