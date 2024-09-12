class CreateStayCities < ActiveRecord::Migration[7.2]
  def change
    create_table :stay_cities do |t|
      t.string :name
      t.references :state, foreign_key: { to_table: :stay_states }

      t.timestamps
    end
  end
end
