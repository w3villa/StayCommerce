class CreateStayStates < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_states do |t|
      t.string   :name
      t.string   :abbr
      t.references :country, null: false, foreign_key: { to_table: :stay_countries }, type: :bigint

      t.timestamps
    end
  end
end
