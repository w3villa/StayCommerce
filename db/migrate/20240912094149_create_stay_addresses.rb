class CreateStayAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_addresses do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :longitude
      t.string :latitude
      t.references :city, foreign_key: { to_table: :stay_cities }
      t.references :state, foreign_key: { to_table: :stay_states }
      t.references :country, foreign_key: { to_table: :stay_countries }

      t.timestamps
    end
  end
end
