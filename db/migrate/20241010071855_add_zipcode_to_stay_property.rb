class AddZipcodeToStayProperty < ActiveRecord::Migration[7.2]
  def change
    add_column :stay_properties, :zipcode, :string
    add_column :stay_properties, :total_bedrooms, :integer
    add_reference :stay_properties, :country, foreign_key: { to_table: :stay_countries }
    add_reference :stay_properties, :state, foreign_key: { to_table: :stay_states }
  end
end
