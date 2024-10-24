class CreateStayFeatures < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_features do |t|
      t.string :name
      t.integer :feature_type

      t.timestamps
    end
  end
end
