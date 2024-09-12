class CreateStayCountries < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_countries do |t|
      t.string   :iso_name
      t.string   :iso, null: false
      t.string   :iso3, null: false
      t.string   :name
      t.integer  :numcode
      t.boolean  :states_required, default: false

      t.timestamps
    end
  end
end
