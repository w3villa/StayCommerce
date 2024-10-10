class CreateStayStoreProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_store_properties do |t|
      t.references :store, null: false, foreign_key: { to_table: :stay_stores }
      t.references :property, null: false, foreign_key: { to_table: :stay_properties }

      t.timestamps
    end
  end
end
